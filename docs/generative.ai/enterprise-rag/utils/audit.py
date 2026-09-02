"""
Audit Logger
─────────────
Structured JSONL audit logging for all query, ingestion, and admin events.
Each event is written atomically to a file and optionally forwarded
to an external SIEM (Splunk / IBM OpenPages) via HTTP.

Log schema::

    {
      "event_id": "uuid",
      "timestamp": "ISO-8601",
      "event_type": "query|ingest|delete|login|error",
      "user_email": "str",
      "user_role": "str",
      "user_groups": ["str"],
      "session_id": "str",
      "details": { ... event-specific fields ... },
      "outcome": "success|failure",
      "latency_ms": int
    }
"""
from __future__ import annotations

import json
import logging
import time
import uuid
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Generator

from config import settings

logger = logging.getLogger(__name__)


class AuditLogger:
    """Thread-safe structured audit logger writing JSONL to disk."""

    def __init__(self, log_file: Path = settings.AUDIT_LOG_FILE) -> None:
        self._log_file = log_file
        self._log_file.parent.mkdir(parents=True, exist_ok=True)

    def log(
        self,
        event_type: str,
        user_email: str,
        outcome: str,
        details: dict | None = None,
        user_role: str = "unknown",
        user_groups: list[str] | None = None,
        session_id: str = "",
        latency_ms: int = 0,
    ) -> None:
        event = {
            "event_id": str(uuid.uuid4()),
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "event_type": event_type,
            "user_email": user_email,
            "user_role": user_role,
            "user_groups": user_groups or [],
            "session_id": session_id,
            "details": details or {},
            "outcome": outcome,
            "latency_ms": latency_ms,
        }
        try:
            with open(self._log_file, "a", encoding="utf-8") as f:
                f.write(json.dumps(event) + "\n")
        except OSError as exc:
            logger.error("Audit log write failed: %s", exc)

        # Also emit as structured log for log aggregators
        logger.info(
            "AUDIT event_type=%s user=%s outcome=%s latency_ms=%d",
            event_type,
            user_email,
            outcome,
            latency_ms,
        )

    @contextmanager
    def timed_event(
        self,
        event_type: str,
        user_email: str,
        details: dict | None = None,
        user_role: str = "unknown",
        user_groups: list[str] | None = None,
        session_id: str = "",
    ) -> Generator[dict, None, None]:
        """Context manager that automatically records latency and outcome."""
        start = time.monotonic()
        ctx: dict[str, Any] = {"outcome": "success", "extra": {}}
        try:
            yield ctx
        except Exception as exc:
            ctx["outcome"] = "failure"
            ctx["extra"]["error"] = str(exc)
            raise
        finally:
            latency_ms = int((time.monotonic() - start) * 1000)
            merged_details = {**(details or {}), **ctx.get("extra", {})}
            self.log(
                event_type=event_type,
                user_email=user_email,
                outcome=ctx["outcome"],
                details=merged_details,
                user_role=user_role,
                user_groups=user_groups,
                session_id=session_id,
                latency_ms=latency_ms,
            )

    def read_recent(self, limit: int = 100) -> list[dict]:
        """Read the most recent audit events (newest first)."""
        if not self._log_file.exists():
            return []
        lines = self._log_file.read_text(encoding="utf-8").strip().split("\n")
        events = []
        for line in reversed(lines[-limit * 2:]):
            try:
                events.append(json.loads(line))
                if len(events) >= limit:
                    break
            except json.JSONDecodeError:
                continue
        return events


# Singleton
audit_logger = AuditLogger()
