"""
PII Scrubber
────────────
Strips personally identifiable information from text before embedding.
Uses Microsoft Presidio when available; falls back to regex patterns.
"""
from __future__ import annotations

import re
import logging

logger = logging.getLogger(__name__)

# Simple regex fallback patterns (when Presidio is not installed)
_PII_PATTERNS = [
    (re.compile(r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b"), "<EMAIL>"),
    (re.compile(r"\b(?:\+?1[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b"), "<PHONE>"),
    (re.compile(r"\b\d{3}-\d{2}-\d{4}\b"), "<SSN>"),
    (re.compile(r"\b(?:\d[ -]?){13,16}\b"), "<CARD>"),
    (re.compile(r"\b[A-Z]{1,2}\d{6,9}\b"), "<PASSPORT>"),
]


def _presidio_scrub(text: str) -> str:
    """Attempt Presidio scrubbing; return original text on import error."""
    try:
        from presidio_analyzer import AnalyzerEngine
        from presidio_anonymizer import AnonymizerEngine

        analyzer = AnalyzerEngine()
        anonymizer = AnonymizerEngine()
        results = analyzer.analyze(text=text, language="en")
        return anonymizer.anonymize(text=text, analyzer_results=results).text
    except ImportError:
        return text


def scrub_pii(text: str, use_presidio: bool = True) -> str:
    """
    Remove PII from *text* before embedding or storage.

    Args:
        text:          Raw document text.
        use_presidio:  Try Presidio first; fall back to regex.

    Returns:
        Anonymised text.
    """
    if use_presidio:
        text = _presidio_scrub(text)

    # Always apply regex as secondary pass
    for pattern, replacement in _PII_PATTERNS:
        text = pattern.sub(replacement, text)

    return text
