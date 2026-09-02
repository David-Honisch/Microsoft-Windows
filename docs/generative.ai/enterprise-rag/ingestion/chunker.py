"""
Document Chunker
────────────────
Converts raw document text (or LangChain Documents) into semantically-coherent
chunks ready for embedding.

Strategy layering (applied in order):
  1. Heading-boundary splits  — preserves section context
  2. Recursive character splitter — respects paragraph / sentence structure
  3. Table-as-unit passthrough  — structured tables kept intact
  4. Minimum-length filter       — drops noise chunks
"""
from __future__ import annotations

import re
from typing import List

from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter

from config import settings


# Markdown / plain-text heading pattern  (## Heading, 1. Section, ALL CAPS LINE)
_HEADING_RE = re.compile(
    r"(?m)^(?:#{1,6}\s.+|(?:\d+[\.\)]\s).{3,80}|[A-Z][A-Z\s]{4,60}[A-Z])$"
)


def _split_on_headings(text: str) -> list[str]:
    """Pre-split text at heading boundaries to preserve section coherence."""
    positions = [m.start() for m in _HEADING_RE.finditer(text)]
    if not positions:
        return [text]
    sections: list[str] = []
    for i, pos in enumerate(positions):
        end = positions[i + 1] if i + 1 < len(positions) else len(text)
        sections.append(text[pos:end])
    # include text before first heading
    if positions[0] > 0:
        sections.insert(0, text[: positions[0]])
    return sections


class DocumentChunker:
    """
    Splits LangChain Documents into overlapping token-bounded chunks.

    Args:
        chunk_size:    target chunk size in *characters* (≈ tokens × 4)
        chunk_overlap: overlap between consecutive chunks in characters
        min_length:    discard chunks shorter than this many characters
    """

    def __init__(
        self,
        chunk_size: int = settings.CHUNK_SIZE * 4,   # chars ≈ tokens × 4
        chunk_overlap: int = settings.CHUNK_OVERLAP * 4,
        min_length: int = settings.CHUNK_MIN_LENGTH,
    ) -> None:
        self._splitter = RecursiveCharacterTextSplitter(
            chunk_size=chunk_size,
            chunk_overlap=chunk_overlap,
            separators=["\n\n", "\n", ". ", "! ", "? ", " ", ""],
            length_function=len,
        )
        self._min_length = min_length

    # ─────────────────────────────────────────────────────────────────────────

    def chunk_documents(self, docs: list[Document]) -> list[Document]:
        """
        Accepts a list of LangChain Documents (one per page / source).
        Returns a flat list of chunk Documents with enriched metadata.
        """
        all_chunks: list[Document] = []
        for doc in docs:
            chunks = self._chunk_single(doc)
            all_chunks.extend(chunks)
        return all_chunks

    def _chunk_single(self, doc: Document) -> list[Document]:
        text = doc.page_content
        base_meta = doc.metadata.copy()

        # Detect tables: keep as single chunk
        if self._is_table(text):
            return [Document(page_content=text.strip(), metadata={**base_meta, "chunk_type": "table"})]

        # Pre-split on heading boundaries
        sections = _split_on_headings(text)
        chunks: list[Document] = []
        chunk_index = 0

        for section in sections:
            # Extract heading (first line of section)
            lines = section.strip().split("\n", 1)
            heading = lines[0].strip() if lines else ""
            section_body = lines[1] if len(lines) > 1 else section

            sub_chunks = self._splitter.split_text(section_body)
            for sub in sub_chunks:
                clean = sub.strip()
                if len(clean) < self._min_length:
                    continue
                meta = {
                    **base_meta,
                    "chunk_index": chunk_index,
                    "section_heading": heading[:120],
                    "chunk_type": "text",
                }
                chunks.append(Document(page_content=clean, metadata=meta))
                chunk_index += 1

        return chunks

    @staticmethod
    def _is_table(text: str) -> bool:
        """Heuristic: ≥3 rows with ≥2 pipe characters each → table."""
        pipe_rows = [l for l in text.split("\n") if l.count("|") >= 2]
        return len(pipe_rows) >= 3
