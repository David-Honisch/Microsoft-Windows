"""
Embedding Manager
─────────────────
Wraps HuggingFace, OpenAI, and Watsonx embedding models behind a single
LangChain-compatible interface.  The embedding model is loaded once at startup
and reused across all ingestion/retrieval calls.
"""
from __future__ import annotations

import logging
from functools import lru_cache
from typing import List

from langchain_core.embeddings import Embeddings

from config import settings

logger = logging.getLogger(__name__)


@lru_cache(maxsize=1)
def get_embedding_model() -> Embeddings:
    """
    Returns a singleton LangChain Embeddings instance.
    Cached so the model is loaded into memory only once.
    """
    model_name = settings.EMBEDDING_MODEL
    logger.info("Loading embedding model: %s", model_name)

    # ── OpenAI text-embedding-3-* ─────────────────────────────────────────
    if model_name.startswith("text-embedding"):
        from langchain_openai import OpenAIEmbeddings
        return OpenAIEmbeddings(
            model=model_name,
            openai_api_key=settings.OPENAI_API_KEY,
        )

    # ── IBM Watsonx slate embeddings ──────────────────────────────────────
    if model_name.startswith("ibm/"):
        try:
            from langchain_ibm import WatsonxEmbeddings
            return WatsonxEmbeddings(
                model_id=model_name,
                url=settings.WATSONX_URL,
                apikey=settings.WATSONX_API_KEY,
                project_id=settings.WATSONX_PROJECT_ID,
            )
        except ImportError:
            logger.warning(
                "langchain-ibm not installed — falling back to HuggingFace embeddings."
            )

    # ── HuggingFace / sentence-transformers (default) ─────────────────────
    from langchain_huggingface import HuggingFaceEmbeddings
    return HuggingFaceEmbeddings(
        model_name=model_name,
        model_kwargs={"device": settings.EMBEDDING_DEVICE},
        encode_kwargs={
            "normalize_embeddings": True,   # cosine similarity needs unit vectors
            "batch_size": settings.EMBEDDING_BATCH_SIZE,
        },
    )
