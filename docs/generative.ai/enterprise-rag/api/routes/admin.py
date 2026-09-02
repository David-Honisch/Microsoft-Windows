"""
Admin Routes
─────────────
GET  /admin/audit-log   — recent audit events
GET  /admin/stats       — system stats (doc count, query count, etc.)
"""
from __future__ import annotations

from typing import Annotated

from fastapi import APIRouter, Depends
from pydantic import BaseModel

from api.auth import TokenData, require_role
from rag.memory import memory_manager
from utils.audit import audit_logger

router = APIRouter(prefix="/admin", tags=["Admin"])


class SystemStats(BaseModel):
    active_sessions: int
    total_audit_events: int


@router.get(
    "/audit-log",
    summary="Retrieve recent audit log entries (admin only)",
)
async def get_audit_log(
    limit: int = 50,
    current_user: Annotated[TokenData, Depends(require_role("admin"))] = None,
):
    return audit_logger.read_recent(limit=limit)


@router.get(
    "/stats",
    response_model=SystemStats,
    summary="Get system statistics (admin only)",
)
async def get_stats(
    current_user: Annotated[TokenData, Depends(require_role("admin"))] = None,
):
    events = audit_logger.read_recent(limit=10000)
    return SystemStats(
        active_sessions=memory_manager.session_count(),
        total_audit_events=len(events),
    )
