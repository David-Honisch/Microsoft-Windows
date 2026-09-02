"""
Ingestion Package
─────────────────
Exports the top-level public surface so callers can do:

    from ingestion import DocumentIngestor
"""
from ingestion.ingestor import DocumentIngestor

__all__ = ["DocumentIngestor"]
