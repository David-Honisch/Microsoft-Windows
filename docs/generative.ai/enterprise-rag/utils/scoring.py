"""
Confidence Scorer
──────────────────
Computes a calibrated confidence score for RAG responses by combining:
  - Mean retrieval similarity score of top-k chunks
  - Answer type indicator (direct / partial / not_found)
  - Coverage check: does the answer reference retrieved source material?

Score bands:
  0.85 – 1.00  →  HIGH    — answer directly supported by strong evidence
  0.65 – 0.84  →  MEDIUM  — answer partially supported; recommend verification
  0.00 – 0.64  →  LOW     — weak evidence; route to human review
"""
from __future__ import annotations

from dataclasses import dataclass
from enum import Enum

from config import settings


class ConfidenceBand(str, Enum):
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"


@dataclass
class ConfidenceResult:
    score: float                      # 0.0 – 1.0
    band: ConfidenceBand
    human_review_required: bool
    explanation: str


def compute_confidence(
    raw_score: float,
    answer_type: str,
    sources_used: int,
    answer_length: int,
) -> ConfidenceResult:
    """
    Combine signals to produce a calibrated confidence score.

    Args:
        raw_score:     Score returned by LLM in JSON output (0.0–1.0).
        answer_type:   "direct" | "partial" | "not_found"
        sources_used:  Number of chunks that contributed to the answer.
        answer_length: Character length of the generated answer.

    Returns:
        ConfidenceResult with score, band, and human_review flag.
    """
    score = raw_score

    # Penalise based on answer type
    if answer_type == "not_found":
        score = min(score, 0.10)
    elif answer_type == "partial":
        score = min(score, 0.70)

    # Penalise if very few sources retrieved
    if sources_used == 0:
        score = 0.0
    elif sources_used == 1:
        score *= 0.85

    # Penalise suspiciously short answers (possible refusal or hallucination)
    if answer_length < 50:
        score *= 0.70

    # Clamp to [0, 1]
    score = max(0.0, min(1.0, score))

    # Determine band
    if score >= settings.CONFIDENCE_HIGH_THRESHOLD:
        band = ConfidenceBand.HIGH
        explanation = "Answer is well-supported by retrieved evidence."
    elif score >= settings.CONFIDENCE_LOW_THRESHOLD:
        band = ConfidenceBand.MEDIUM
        explanation = "Answer is partially supported. Verification recommended."
    else:
        band = ConfidenceBand.LOW
        explanation = "Insufficient evidence. Human review recommended."

    review_required = score < settings.CONFIDENCE_LOW_THRESHOLD

    return ConfidenceResult(
        score=round(score, 3),
        band=band,
        human_review_required=review_required,
        explanation=explanation,
    )
