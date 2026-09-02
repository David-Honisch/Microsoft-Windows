"""
Query / Chat Routes
────────────────────
POST /query/ask         — single-turn RAG query
POST /query/chat        — multi-turn conversational RAG
POST /query/feedback    — submit thumbs-up/down feedback on a response
GET  /query/history/{session_id}  — retrieve conversation history
"""
from __future__ import annotations

import logging
import uuid
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field

from api.auth import TokenData, get_current_user
from rag.memory import memory_manager
from utils.audit import audit_logger
from utils.scoring import compute_confidence

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/query", tags=["Query"])


# ── Request / Response Models ─────────────────────────────────────────────────

class QueryRequest(BaseModel):
    question: str = Field(..., min_length=3, max_length=2000)
    session_id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    doc_type: str | None = Field(None, description="Filter by doc type (optional)")
    use_hyde: bool = Field(True, description="Enable HyDE query expansion")


class Citation(BaseModel):
    doc_title: str
    page: int
    section: str
    relevance_score: float


class QueryResponse(BaseModel):
    answer: str
    citations: list[Citation]
    confidence: float
    confidence_band: str
    answer_type: str
    follow_up_suggestions: list[str]
    sources_used: int
    session_id: str
    human_review_required: bool
    review_reason: str = ""


class FeedbackRequest(BaseModel):
    session_id: str
    question: str
    answer: str
    rating: int = Field(..., ge=1, le=5, description="1–5 rating (5 = excellent)")
    comment: str = ""


# ── Endpoints ─────────────────────────────────────────────────────────────────

@router.post(
    "/ask",
    response_model=QueryResponse,
    summary="Ask a single-turn question against the knowledge base",
)
async def ask(
    request: QueryRequest,
    current_user: Annotated[TokenData, Depends(get_current_user)],
):
    from api.dependencies import get_rag_chain
    chain = get_rag_chain()

    with audit_logger.timed_event(
        event_type="query",
        user_email=current_user.email,
        details={"question": request.question[:200], "session_id": request.session_id},
        user_role=current_user.role,
        user_groups=current_user.groups,
        session_id=request.session_id,
    ) as ctx:
        result = chain.query(
            question=request.question,
            session_id=request.session_id,
            user_groups=current_user.groups,
            doc_type=request.doc_type,
            use_hyde=request.use_hyde,
        )
        ctx["extra"]["answer_type"] = result.get("answer_type")
        ctx["extra"]["confidence"] = result.get("confidence")

    # Re-compute confidence through our calibration layer
    conf_result = compute_confidence(
        raw_score=result.get("confidence", 0.0),
        answer_type=result.get("answer_type", "not_found"),
        sources_used=result.get("sources_used", 0),
        answer_length=len(result.get("answer", "")),
    )

    citations = [
        Citation(
            doc_title=c.get("doc_title", ""),
            page=c.get("page", 0),
            section=c.get("section", ""),
            relevance_score=c.get("relevance_score", 0.0),
        )
        for c in result.get("citations", [])
    ]

    return QueryResponse(
        answer=result.get("answer", ""),
        citations=citations,
        confidence=conf_result.score,
        confidence_band=conf_result.band.value,
        answer_type=result.get("answer_type", "not_found"),
        follow_up_suggestions=result.get("follow_up_suggestions", []),
        sources_used=result.get("sources_used", 0),
        session_id=result.get("session_id", request.session_id),
        human_review_required=conf_result.human_review_required,
        review_reason=conf_result.explanation,
    )


@router.post(
    "/chat",
    response_model=QueryResponse,
    summary="Multi-turn conversational query (uses session memory)",
)
async def chat(
    request: QueryRequest,
    current_user: Annotated[TokenData, Depends(get_current_user)],
):
    # /chat and /ask are identical in behaviour — session memory is keyed by session_id
    return await ask(request, current_user)


@router.post("/feedback", summary="Submit answer quality feedback")
async def submit_feedback(
    feedback: FeedbackRequest,
    current_user: Annotated[TokenData, Depends(get_current_user)],
):
    audit_logger.log(
        event_type="feedback",
        user_email=current_user.email,
        outcome="success",
        details={
            "session_id": feedback.session_id,
            "question": feedback.question[:200],
            "rating": feedback.rating,
            "comment": feedback.comment[:500],
        },
        user_role=current_user.role,
        user_groups=current_user.groups,
        session_id=feedback.session_id,
    )
    return {"message": "Feedback recorded. Thank you!"}


@router.delete(
    "/history/{session_id}",
    summary="Clear conversation history for a session",
)
async def clear_history(
    session_id: str,
    current_user: Annotated[TokenData, Depends(get_current_user)],
):
    memory_manager.clear(session_id)
    return {"message": f"Conversation history cleared for session {session_id}."}
