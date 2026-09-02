"""
RAG Chain
──────────
LangChain LCEL chain that wires together:
  HyDE query expansion → hybrid retrieval → re-ranking
  → context assembly → prompt → LLM → JSON output parsing → citation mapping
"""
from __future__ import annotations

import json
import logging
import re
import tiktoken
from typing import Any

from langchain_core.documents import Document
from langchain_core.language_models import BaseChatModel
from langchain_core.output_parsers import StrOutputParser

from config import settings, LLMProvider
from rag.prompts import RAG_PROMPT, HYDE_PROMPT, QUERY_EXPANSION_PROMPT
from rag.memory import memory_manager

logger = logging.getLogger(__name__)


# ── LLM Factory ───────────────────────────────────────────────────────────────

def build_llm() -> BaseChatModel:
    """Instantiate the configured LLM provider."""
    provider = settings.LLM_PROVIDER

    if provider == LLMProvider.OPENAI:
        from langchain_openai import ChatOpenAI
        return ChatOpenAI(
            model=settings.OPENAI_MODEL,
            temperature=settings.OPENAI_TEMPERATURE,
            max_tokens=settings.OPENAI_MAX_TOKENS,
            api_key=settings.OPENAI_API_KEY,
            streaming=True,
        )

    if provider == LLMProvider.WATSONX:
        try:
            from langchain_ibm import ChatWatsonx
            return ChatWatsonx(
                model_id=settings.WATSONX_MODEL_ID,
                url=settings.WATSONX_URL,
                apikey=settings.WATSONX_API_KEY,
                project_id=settings.WATSONX_PROJECT_ID,
                params={
                    "temperature": 0.0,
                    "max_new_tokens": settings.OPENAI_MAX_TOKENS,
                    "repetition_penalty": 1.1,
                },
            )
        except ImportError:
            logger.error("langchain-ibm not installed. Falling back to OpenAI.")
            return build_llm.__wrapped__()  # type: ignore

    if provider == LLMProvider.HUGGINGFACE:
        from langchain_huggingface import HuggingFaceEndpoint
        return HuggingFaceEndpoint(  # type: ignore[return-value]
            repo_id="HuggingFaceH4/zephyr-7b-beta",
            temperature=0.01,
            max_new_tokens=settings.OPENAI_MAX_TOKENS,
        )

    raise ValueError(f"Unknown LLM provider: {provider}")


# ── Token Counter ─────────────────────────────────────────────────────────────

def _count_tokens(text: str, model: str = "gpt-4o") -> int:
    try:
        enc = tiktoken.encoding_for_model(model)
        return len(enc.encode(text))
    except Exception:
        return len(text) // 4  # fallback: 1 token ≈ 4 chars


def _trim_context(chunks: list[Document], budget: int) -> list[Document]:
    """Drop least-relevant chunks (tail) to stay within token budget."""
    used = 0
    kept: list[Document] = []
    for chunk in chunks:
        t = _count_tokens(chunk.page_content)
        if used + t > budget:
            break
        kept.append(chunk)
        used += t
    return kept


# ── Context Formatter ─────────────────────────────────────────────────────────

def _format_context(chunks: list[Document]) -> str:
    """
    Format retrieved chunks into a structured context string.
    Each chunk is labelled with its source for easy citation lookup.
    """
    parts: list[str] = []
    for i, doc in enumerate(chunks, start=1):
        meta = doc.metadata
        label = (
            f"[{i}] Source: {meta.get('source_filename', 'Unknown')}"
            f" | Page: {meta.get('page', '?')}"
            f" | Section: {meta.get('section_heading', 'N/A')}"
            f" | Type: {meta.get('doc_type', 'general')}"
        )
        parts.append(f"{label}\n{doc.page_content}")
    return "\n\n---\n\n".join(parts)


# ── RAG Chain ─────────────────────────────────────────────────────────────────

class RAGChain:
    """
    Orchestrates the full RAG query pipeline.

    Usage::

        chain = RAGChain(vector_store)
        result = chain.query(
            question="What is the expense policy for home office?",
            session_id="user-123",
            user_groups=["hr", "all_staff"],
        )
    """

    def __init__(self, vector_store: Any) -> None:
        self._store = vector_store
        self._llm = build_llm()
        self._str_parser = StrOutputParser()

    # ─────────────────────────────────────────────────────────────────────────

    def query(
        self,
        question: str,
        session_id: str,
        user_groups: list[str],
        doc_type: str | None = None,
        use_hyde: bool = True,
    ) -> dict:
        """
        Execute the full RAG pipeline and return a structured response dict.

        Returns:
            {
                "answer": str,
                "citations": list[dict],
                "confidence": float,
                "answer_type": str,
                "follow_up_suggestions": list[str],
                "sources_used": int,
                "session_id": str,
            }
        """
        # ── 1. Query expansion via HyDE ───────────────────────────────────────
        search_query = question
        if use_hyde:
            try:
                search_query = self._hyde_expand(question)
            except Exception as exc:
                logger.warning("HyDE expansion failed: %s", exc)

        # ── 2. Retrieve chunks ────────────────────────────────────────────────
        chunks = self._store.retrieve(
            query=search_query,
            user_groups=user_groups,
            top_k=settings.RETRIEVAL_TOP_K,
            top_n=settings.RERANK_TOP_N,
            doc_type=doc_type,
        )

        if not chunks:
            return self._not_found_response(session_id)

        # ── 3. Trim to token budget ───────────────────────────────────────────
        chunks = _trim_context(chunks, settings.MAX_CONTEXT_TOKENS)

        # ── 4. Format context ─────────────────────────────────────────────────
        context = _format_context(chunks)

        # ── 5. Conversation history ───────────────────────────────────────────
        history = memory_manager.format_history(session_id)

        # ── 6. Invoke LLM via RAG prompt ──────────────────────────────────────
        chain = RAG_PROMPT | self._llm | self._str_parser
        raw_response = chain.invoke({
            "context": context,
            "chat_history": history or "No prior conversation.",
            "question": question,
        })

        # ── 7. Parse JSON output ──────────────────────────────────────────────
        parsed = self._parse_json_response(raw_response)

        # ── 8. Enrich with source metadata ───────────────────────────────────
        parsed["sources_used"] = len(chunks)
        parsed["session_id"] = session_id
        parsed["retrieved_chunks"] = [
            {
                "content": c.page_content[:300] + "…" if len(c.page_content) > 300 else c.page_content,
                "metadata": c.metadata,
            }
            for c in chunks
        ]

        # ── 9. Flag low-confidence answers ───────────────────────────────────
        confidence = parsed.get("confidence", 0.0)
        if confidence < settings.CONFIDENCE_LOW_THRESHOLD:
            parsed["human_review_required"] = True
            parsed["review_reason"] = f"Low confidence score: {confidence:.2f}"
        else:
            parsed["human_review_required"] = False

        # ── 10. Store turn in memory ──────────────────────────────────────────
        memory_manager.add_turn(session_id, "user", question)
        memory_manager.add_turn(session_id, "assistant", parsed.get("answer", ""))

        return parsed

    # ── HyDE Expansion ────────────────────────────────────────────────────────

    def _hyde_expand(self, question: str) -> str:
        """Generate a hypothetical document passage for richer vector search."""
        chain = HYDE_PROMPT | self._llm | self._str_parser
        hypothesis = chain.invoke({"question": question})
        # Combine original question + hypothesis for best of both
        return f"{question}\n\n{hypothesis}"

    # ── Output Parsing ────────────────────────────────────────────────────────

    def _parse_json_response(self, raw: str) -> dict:
        """
        Extract JSON from LLM output.
        LLMs sometimes wrap JSON in markdown code fences — strip them first.
        """
        # Strip markdown fences
        clean = re.sub(r"^```(?:json)?\s*", "", raw.strip(), flags=re.IGNORECASE)
        clean = re.sub(r"\s*```$", "", clean.strip())

        try:
            return json.loads(clean)
        except json.JSONDecodeError:
            logger.warning("JSON parse failed; returning raw response as answer.")
            return {
                "answer": raw.strip(),
                "citations": [],
                "confidence": 0.5,
                "answer_type": "partial",
                "follow_up_suggestions": [],
            }

    # ── Not Found Response ────────────────────────────────────────────────────

    @staticmethod
    def _not_found_response(session_id: str) -> dict:
        return {
            "answer": (
                "I was unable to find relevant information in the available documents. "
                "Please consult the relevant department directly or refine your question."
            ),
            "citations": [],
            "confidence": 0.0,
            "answer_type": "not_found",
            "follow_up_suggestions": [
                "Can you rephrase the question with more specific terms?",
                "Which document or policy are you referring to?",
            ],
            "sources_used": 0,
            "session_id": session_id,
            "retrieved_chunks": [],
            "human_review_required": True,
            "review_reason": "No relevant documents retrieved.",
        }
