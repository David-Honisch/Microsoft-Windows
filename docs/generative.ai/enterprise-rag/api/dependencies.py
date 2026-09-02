"""
Dependency Injection
─────────────────────
Singleton factories for the VectorStoreManager, DocumentIngestor, and RAGChain.
Using module-level singletons avoids re-loading embedding models on every request.
"""
from __future__ import annotations

import logging

logger = logging.getLogger(__name__)

_store = None
_ingestor = None
_rag_chain = None


def get_store():
    global _store
    if _store is None:
        from vectorstore.store import VectorStoreManager
        logger.info("Initialising VectorStoreManager...")
        _store = VectorStoreManager()
    return _store


def get_ingestor():
    global _ingestor
    if _ingestor is None:
        from ingestion.ingestor import DocumentIngestor
        logger.info("Initialising DocumentIngestor...")
        _ingestor = DocumentIngestor(get_store())
    return _ingestor


def get_rag_chain():
    global _rag_chain
    if _rag_chain is None:
        from rag.chain import RAGChain
        logger.info("Initialising RAGChain...")
        _rag_chain = RAGChain(get_store())
    return _rag_chain
