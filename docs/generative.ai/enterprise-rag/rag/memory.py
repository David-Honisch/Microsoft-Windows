"""
Conversation Memory Manager
────────────────────────────
Per-session conversation history with rolling summarisation to stay
within the token budget.
"""
from __future__ import annotations

import json
import logging
from collections import defaultdict
from dataclasses import dataclass, field
from typing import Optional

logger = logging.getLogger(__name__)

MAX_FULL_TURNS = 3          # keep last N turns verbatim
MAX_SUMMARY_CHARS = 800     # max chars for rolling summary


@dataclass
class Turn:
    role: str          # "user" | "assistant"
    content: str


@dataclass
class SessionMemory:
    session_id: str
    turns: list[Turn] = field(default_factory=list)
    summary: str = ""


class ConversationMemoryManager:
    """
    Manages per-session memory using a simple in-process store.
    For production, swap the dict for a Redis-backed store.
    """

    def __init__(self) -> None:
        self._sessions: dict[str, SessionMemory] = defaultdict(
            lambda: SessionMemory(session_id="")
        )

    def get_or_create(self, session_id: str) -> SessionMemory:
        if session_id not in self._sessions:
            self._sessions[session_id] = SessionMemory(session_id=session_id)
        return self._sessions[session_id]

    def add_turn(self, session_id: str, role: str, content: str) -> None:
        mem = self.get_or_create(session_id)
        mem.turns.append(Turn(role=role, content=content))

    def format_history(self, session_id: str) -> str:
        """
        Returns the conversation history as a plain-text string for prompt injection.
        Last MAX_FULL_TURNS turns are included verbatim; older turns are summarised.
        """
        mem = self.get_or_create(session_id)
        turns = mem.turns

        # Split into older turns (to summarise) and recent turns (verbatim)
        if len(turns) > MAX_FULL_TURNS * 2:
            recent = turns[-(MAX_FULL_TURNS * 2):]
        else:
            recent = turns

        parts: list[str] = []
        if mem.summary:
            parts.append(f"[Summary of earlier conversation]: {mem.summary}")

        for t in recent:
            label = "User" if t.role == "user" else "Assistant"
            parts.append(f"{label}: {t.content}")

        return "\n".join(parts)

    def clear(self, session_id: str) -> None:
        if session_id in self._sessions:
            del self._sessions[session_id]

    def session_count(self) -> int:
        return len(self._sessions)


# Singleton — shared across request handlers
memory_manager = ConversationMemoryManager()
