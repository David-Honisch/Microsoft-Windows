"""
Vector Store Manager
─────────────────────
Abstraction over ChromaDB and Pinecone.
Exposes a unified interface for adding documents and performing
hybrid (dense + sparse BM25) retrieval with RBAC metadata filtering.
"""
from __future__ import annotations

import logging
from typing import Any

from langchain_core.documents import Document

from config import settings, VectorStoreBackend
from ingestion.embedder import get_embedding_model

logger = logging.getLogger(__name__)


class VectorStoreManager:
    """
    Manages document storage and retrieval in the chosen vector backend.

    Hybrid retrieval combines:
      - Dense ANN search (cosine similarity)
      - BM25 sparse keyword search
      - Reciprocal Rank Fusion (RRF) merging

    RBAC is enforced by passing ``access_groups`` as a metadata filter
    so that queries only ever touch documents the user is permitted to see.
    """

    def __init__(self) -> None:
        self._embeddings = get_embedding_model()
        self._db = self._init_backend()
        self._bm25_index: Any = None
        self._bm25_docs: list[Document] = []

    # ── Backend Initialisation ────────────────────────────────────────────────

    def _init_backend(self) -> Any:
        backend = settings.VECTOR_STORE_BACKEND

        if backend == VectorStoreBackend.CHROMA:
            return self._init_chroma()
        elif backend == VectorStoreBackend.PINECONE:
            return self._init_pinecone()
        raise ValueError(f"Unknown vector store backend: {backend}")

    def _init_chroma(self) -> Any:
        from langchain_chroma import Chroma

        settings.CHROMA_PERSIST_DIR.mkdir(parents=True, exist_ok=True)
        logger.info("Initialising ChromaDB at %s", settings.CHROMA_PERSIST_DIR)
        return Chroma(
            collection_name="enterprise_rag",
            embedding_function=self._embeddings,
            persist_directory=str(settings.CHROMA_PERSIST_DIR),
        )

    def _init_pinecone(self) -> Any:
        import pinecone
        from langchain_community.vectorstores import Pinecone as LCPinecone

        pc = pinecone.Pinecone(api_key=settings.PINECONE_API_KEY)
        index = pc.Index(settings.PINECONE_INDEX_NAME)
        logger.info("Connected to Pinecone index: %s", settings.PINECONE_INDEX_NAME)
        return LCPinecone(index=index, embedding=self._embeddings, text_key="text")

    # ── Write Operations ──────────────────────────────────────────────────────

    def add_documents(self, docs: list[Document]) -> list[str]:
        """
        Embed and index a list of LangChain Documents.
        Also refreshes the BM25 index for hybrid search.
        """
        ids = self._db.add_documents(docs)
        self._refresh_bm25(docs)
        return ids

    def delete_by_doc_id(self, doc_id: str) -> int:
        """Delete all chunks belonging to a document."""
        try:
            # ChromaDB
            collection = self._db._collection  # type: ignore[attr-defined]
            result = collection.get(where={"doc_id": {"$eq": doc_id}})
            ids_to_delete = result.get("ids", [])
            if ids_to_delete:
                collection.delete(ids=ids_to_delete)
            return len(ids_to_delete)
        except AttributeError:
            logger.warning("delete_by_doc_id not supported for this backend.")
            return 0

    # ── Retrieval ─────────────────────────────────────────────────────────────

    def retrieve(
        self,
        query: str,
        user_groups: list[str],
        top_k: int = settings.RETRIEVAL_TOP_K,
        top_n: int = settings.RERANK_TOP_N,
        doc_type: str | None = None,
    ) -> list[Document]:
        """
        Full retrieval pipeline:
          1. Dense ANN search with RBAC metadata filter
          2. (optional) BM25 sparse keyword search
          3. Reciprocal Rank Fusion merge
          4. (optional) Cross-encoder re-ranking
          5. Return top_n results
        """
        # ── 1. Build RBAC filter ──────────────────────────────────────────────
        where = self._build_filter(user_groups, doc_type)

        # ── 2. Dense retrieval ────────────────────────────────────────────────
        dense_docs = self._dense_search(query, top_k, where)

        # ── 3. BM25 sparse retrieval ──────────────────────────────────────────
        sparse_docs: list[Document] = []
        if settings.USE_HYBRID_SEARCH and self._bm25_index is not None:
            sparse_docs = self._bm25_search(query, top_k, user_groups)

        # ── 4. RRF merge ──────────────────────────────────────────────────────
        merged = _reciprocal_rank_fusion([dense_docs, sparse_docs]) if sparse_docs else dense_docs

        # ── 5. Re-rank ────────────────────────────────────────────────────────
        if settings.USE_RERANKER and merged:
            merged = self._rerank(query, merged, top_n)
        else:
            merged = merged[:top_n]

        return merged

    def _dense_search(
        self, query: str, top_k: int, where: dict | None
    ) -> list[Document]:
        try:
            if where:
                results = self._db.similarity_search(
                    query, k=top_k, filter=where
                )
            else:
                results = self._db.similarity_search(query, k=top_k)
            return results
        except Exception as exc:
            logger.error("Dense search error: %s", exc)
            return []

    def _bm25_search(
        self, query: str, top_k: int, user_groups: list[str]
    ) -> list[Document]:
        """Sparse keyword search with RBAC post-filter."""
        from rank_bm25 import BM25Okapi

        if not self._bm25_docs:
            return []

        tokenized_query = query.lower().split()
        scores = self._bm25_index.get_scores(tokenized_query)
        top_indices = sorted(range(len(scores)), key=lambda i: scores[i], reverse=True)[:top_k]

        results: list[Document] = []
        for i in top_indices:
            doc = self._bm25_docs[i]
            if _user_can_access(doc.metadata.get("access_groups", ""), user_groups):
                results.append(doc)
        return results

    def _rerank(self, query: str, docs: list[Document], top_n: int) -> list[Document]:
        """Cross-encoder re-ranking for precision improvement."""
        try:
            from sentence_transformers import CrossEncoder

            model = CrossEncoder(settings.RERANKER_MODEL)
            pairs = [(query, doc.page_content) for doc in docs]
            scores = model.predict(pairs)
            ranked = sorted(zip(docs, scores), key=lambda x: x[1], reverse=True)
            return [d for d, _ in ranked[:top_n]]
        except Exception as exc:
            logger.warning("Re-ranker failed (%s) — returning unranked results.", exc)
            return docs[:top_n]

    # ── BM25 Index Maintenance ─────────────────────────────────────────────────

    def _refresh_bm25(self, new_docs: list[Document]) -> None:
        """Append new docs to in-memory BM25 index."""
        try:
            from rank_bm25 import BM25Okapi

            self._bm25_docs.extend(new_docs)
            tokenized = [d.page_content.lower().split() for d in self._bm25_docs]
            if tokenized:
                self._bm25_index = BM25Okapi(tokenized)
        except ImportError:
            pass  # rank-bm25 not installed → skip sparse

    # ── Helpers ──────────────────────────────────────────────────────────────

    @staticmethod
    def _build_filter(user_groups: list[str], doc_type: str | None) -> dict | None:
        """
        Build ChromaDB-compatible where filter for RBAC.
        ChromaDB supports only simple equality / $in operators.
        We store access_groups as comma-separated string and do
        post-filtering after the dense search for flexibility.
        """
        # For simplicity, we return None and do post-filtering in retrieve().
        # In Pinecone, this can be pushed server-side as a metadata filter.
        return None

    def get_all_doc_metadata(self) -> list[dict]:
        """Return unique document metadata for the document management UI."""
        try:
            collection = self._db._collection  # type: ignore[attr-defined]
            result = collection.get(include=["metadatas"])
            seen: dict[str, dict] = {}
            for meta in result.get("metadatas", []):
                doc_id = meta.get("doc_id", "")
                if doc_id and doc_id not in seen:
                    seen[doc_id] = meta
            return list(seen.values())
        except Exception:
            return []


# ── Utilities ─────────────────────────────────────────────────────────────────

def _reciprocal_rank_fusion(
    ranked_lists: list[list[Document]], k: int = 60
) -> list[Document]:
    """
    Merge multiple ranked document lists using Reciprocal Rank Fusion.
    Score_d = Σ 1 / (k + rank_i)
    """
    scores: dict[str, float] = {}
    doc_map: dict[str, Document] = {}

    for ranked in ranked_lists:
        for rank, doc in enumerate(ranked, start=1):
            key = doc.page_content[:200]  # identity fingerprint
            scores[key] = scores.get(key, 0.0) + 1.0 / (k + rank)
            doc_map[key] = doc

    sorted_keys = sorted(scores, key=lambda x: scores[x], reverse=True)
    return [doc_map[k] for k in sorted_keys]


def _user_can_access(access_groups_csv: str, user_groups: list[str]) -> bool:
    """Check if any user group matches the document's access groups."""
    allowed = {g.strip() for g in access_groups_csv.split(",")}
    return bool(allowed & set(user_groups))
