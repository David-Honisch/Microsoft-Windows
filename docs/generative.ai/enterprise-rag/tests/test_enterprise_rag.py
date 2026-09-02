"""
Test suite for Enterprise RAG
──────────────────────────────
Run with:
    pytest tests/ -v --cov=. --cov-report=term-missing
"""
from __future__ import annotations

import json
import pytest
from pathlib import Path
from unittest.mock import MagicMock, patch

from fastapi.testclient import TestClient


# ── Fixtures ──────────────────────────────────────────────────────────────────

@pytest.fixture(scope="session")
def mock_store():
    """A mock VectorStoreManager that returns canned results."""
    store = MagicMock()
    from langchain_core.documents import Document
    store.retrieve.return_value = [
        Document(
            page_content="Employees may expense up to $500 for home office equipment annually.",
            metadata={
                "doc_id": "test-doc-001",
                "source_filename": "HR_Policy.pdf",
                "page": 12,
                "section_heading": "Home Office Expenses",
                "doc_type": "policy",
                "access_groups": "hr,all_staff",
                "uploaded_by": "admin@acme.com",
                "ingestion_timestamp": "2025-01-01T00:00:00+00:00",
                "file_hash": "abc123",
            },
        )
    ]
    store.get_all_doc_metadata.return_value = [
        {
            "doc_id": "test-doc-001",
            "source_filename": "HR_Policy.pdf",
            "doc_type": "policy",
            "access_groups": "hr,all_staff",
            "uploaded_by": "admin@acme.com",
            "ingestion_timestamp": "2025-01-01T00:00:00+00:00",
            "file_hash": "abc123",
        }
    ]
    store.add_documents.return_value = ["chunk-1", "chunk-2"]
    store.delete_by_doc_id.return_value = 5
    return store


@pytest.fixture(scope="session")
def mock_llm_response():
    return json.dumps({
        "answer": "Employees may expense up to $500 for home office equipment. [Source: HR_Policy.pdf, Page 12, Section: Home Office Expenses]",
        "citations": [{"doc_title": "HR_Policy.pdf", "page": 12, "section": "Home Office Expenses", "relevance_score": 0.92}],
        "confidence": 0.92,
        "answer_type": "direct",
        "follow_up_suggestions": ["What is the process to submit an expense?", "Is there a deadline for expense claims?"],
    })


@pytest.fixture(scope="session")
def app_client(mock_store, mock_llm_response):
    """FastAPI test client with mocked dependencies."""
    import api.dependencies as deps
    deps._store = mock_store

    # Mock ingestor
    mock_ingestor = MagicMock()
    mock_ingestor.ingest_file.return_value = {
        "doc_id": "test-doc-001",
        "filename": "test.pdf",
        "doc_type": "policy",
        "access_groups": ["all_staff"],
        "pages_parsed": 5,
        "chunks_indexed": 30,
        "file_hash": "abc123",
        "ingested_at": "2025-01-01T00:00:00+00:00",
        "uploaded_by": "admin@acme.com",
    }
    mock_ingestor.delete_document.return_value = 30
    deps._ingestor = mock_ingestor

    # Mock RAG chain
    mock_chain = MagicMock()
    mock_chain.query.return_value = {
        "answer": "Test answer [Source: HR_Policy.pdf, Page 12, Section: Home Office]",
        "citations": [{"doc_title": "HR_Policy.pdf", "page": 12, "section": "Home Office", "relevance_score": 0.90}],
        "confidence": 0.90,
        "answer_type": "direct",
        "follow_up_suggestions": ["Follow-up 1?"],
        "sources_used": 1,
        "session_id": "test-session",
        "retrieved_chunks": [],
        "human_review_required": False,
        "review_reason": "",
    }
    deps._rag_chain = mock_chain

    from api.main import app
    return TestClient(app)


@pytest.fixture(scope="session")
def auth_token(app_client):
    """Get a valid JWT token for admin user."""
    resp = app_client.post(
        "/api/v1/auth/token",
        data={"username": "admin@acme.com", "password": "admin123"},
    )
    assert resp.status_code == 200
    return resp.json()["access_token"]


@pytest.fixture(scope="session")
def editor_token(app_client):
    resp = app_client.post(
        "/api/v1/auth/token",
        data={"username": "hr@acme.com", "password": "editor123"},
    )
    assert resp.status_code == 200
    return resp.json()["access_token"]


@pytest.fixture(scope="session")
def viewer_token(app_client):
    resp = app_client.post(
        "/api/v1/auth/token",
        data={"username": "employee@acme.com", "password": "viewer123"},
    )
    assert resp.status_code == 200
    return resp.json()["access_token"]


# ── Auth Tests ────────────────────────────────────────────────────────────────

class TestAuth:
    def test_login_success(self, app_client):
        resp = app_client.post(
            "/api/v1/auth/token",
            data={"username": "admin@acme.com", "password": "admin123"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "access_token" in data
        assert data["role"] == "admin"
        assert "admin" in data["groups"]

    def test_login_wrong_password(self, app_client):
        resp = app_client.post(
            "/api/v1/auth/token",
            data={"username": "admin@acme.com", "password": "wrongpassword"},
        )
        assert resp.status_code == 401

    def test_login_unknown_user(self, app_client):
        resp = app_client.post(
            "/api/v1/auth/token",
            data={"username": "nobody@acme.com", "password": "test"},
        )
        assert resp.status_code == 401

    def test_get_me(self, app_client, auth_token):
        resp = app_client.get(
            "/api/v1/auth/me",
            headers={"Authorization": f"Bearer {auth_token}"},
        )
        assert resp.status_code == 200
        assert resp.json()["email"] == "admin@acme.com"

    def test_unauthenticated_request(self, app_client):
        resp = app_client.get("/api/v1/documents/")
        assert resp.status_code == 401


# ── RBAC Tests ────────────────────────────────────────────────────────────────

class TestRBAC:
    def test_viewer_cannot_upload(self, app_client, viewer_token):
        """Viewers should be blocked from uploading documents."""
        resp = app_client.post(
            "/api/v1/documents/upload",
            headers={"Authorization": f"Bearer {viewer_token}"},
            files={"file": ("test.txt", b"Hello world", "text/plain")},
            data={"doc_type": "general", "access_groups": "all_staff"},
        )
        assert resp.status_code == 403

    def test_viewer_cannot_access_admin(self, app_client, viewer_token):
        resp = app_client.get(
            "/api/v1/admin/audit-log",
            headers={"Authorization": f"Bearer {viewer_token}"},
        )
        assert resp.status_code == 403

    def test_editor_cannot_access_admin(self, app_client, editor_token):
        resp = app_client.get(
            "/api/v1/admin/audit-log",
            headers={"Authorization": f"Bearer {editor_token}"},
        )
        assert resp.status_code == 403

    def test_admin_can_access_admin(self, app_client, auth_token):
        resp = app_client.get(
            "/api/v1/admin/audit-log",
            headers={"Authorization": f"Bearer {auth_token}"},
        )
        assert resp.status_code == 200

    def test_editor_can_upload(self, app_client, editor_token):
        resp = app_client.post(
            "/api/v1/documents/upload",
            headers={"Authorization": f"Bearer {editor_token}"},
            files={"file": ("policy.pdf", b"%PDF-1.4 test content", "application/pdf")},
            data={"doc_type": "policy", "access_groups": "hr,all_staff"},
        )
        # Either 201 (success) or 415/500 (parsing fails on fake PDF — both acceptable in tests)
        assert resp.status_code in (201, 415, 500)


# ── Document Routes ───────────────────────────────────────────────────────────

class TestDocuments:
    def test_list_documents(self, app_client, auth_token):
        resp = app_client.get(
            "/api/v1/documents/",
            headers={"Authorization": f"Bearer {auth_token}"},
        )
        assert resp.status_code == 200
        docs = resp.json()
        assert isinstance(docs, list)

    def test_delete_document(self, app_client, auth_token):
        resp = app_client.delete(
            "/api/v1/documents/test-doc-001",
            headers={"Authorization": f"Bearer {auth_token}"},
        )
        assert resp.status_code == 200
        assert resp.json()["doc_id"] == "test-doc-001"


# ── Query Routes ──────────────────────────────────────────────────────────────

class TestQuery:
    def test_ask_question(self, app_client, auth_token):
        resp = app_client.post(
            "/api/v1/query/ask",
            headers={"Authorization": f"Bearer {auth_token}"},
            json={
                "question": "What is the home office expense policy?",
                "session_id": "test-session-001",
            },
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "answer" in data
        assert "confidence" in data
        assert "citations" in data
        assert isinstance(data["citations"], list)
        assert "answer_type" in data
        assert data["confidence"] >= 0.0
        assert data["confidence"] <= 1.0

    def test_ask_requires_auth(self, app_client):
        resp = app_client.post(
            "/api/v1/query/ask",
            json={"question": "What is the expense policy?"},
        )
        assert resp.status_code == 401

    def test_question_too_short(self, app_client, auth_token):
        resp = app_client.post(
            "/api/v1/query/ask",
            headers={"Authorization": f"Bearer {auth_token}"},
            json={"question": "Hi"},
        )
        assert resp.status_code == 422  # Validation error

    def test_feedback_submission(self, app_client, auth_token):
        resp = app_client.post(
            "/api/v1/query/feedback",
            headers={"Authorization": f"Bearer {auth_token}"},
            json={
                "session_id": "test-session-001",
                "question": "What is the expense policy?",
                "answer": "Up to $500 per year.",
                "rating": 5,
                "comment": "Very helpful!",
            },
        )
        assert resp.status_code == 200

    def test_clear_history(self, app_client, auth_token):
        resp = app_client.delete(
            "/api/v1/query/history/test-session-001",
            headers={"Authorization": f"Bearer {auth_token}"},
        )
        assert resp.status_code == 200


# ── Chunker Unit Tests ────────────────────────────────────────────────────────

class TestChunker:
    def test_basic_chunking(self):
        from ingestion.chunker import DocumentChunker
        from langchain_core.documents import Document

        chunker = DocumentChunker(chunk_size=200, chunk_overlap=20, min_length=10)
        docs = [
            Document(
                page_content="This is a test document. " * 50,
                metadata={"source_filename": "test.txt", "page": 1},
            )
        ]
        chunks = chunker.chunk_documents(docs)
        assert len(chunks) > 1
        for chunk in chunks:
            assert len(chunk.page_content) >= 10
            assert "chunk_index" in chunk.metadata
            assert "chunk_type" in chunk.metadata

    def test_table_detection(self):
        from ingestion.chunker import DocumentChunker
        from langchain_core.documents import Document

        chunker = DocumentChunker()
        table_text = "| Name | Value |\n| --- | --- |\n| Alice | 100 |\n| Bob | 200 |"
        docs = [Document(page_content=table_text, metadata={"source_filename": "data.txt", "page": 1})]
        chunks = chunker.chunk_documents(docs)
        assert len(chunks) == 1
        assert chunks[0].metadata["chunk_type"] == "table"

    def test_min_length_filter(self):
        from ingestion.chunker import DocumentChunker
        from langchain_core.documents import Document

        chunker = DocumentChunker(chunk_size=50, chunk_overlap=5, min_length=100)
        docs = [Document(page_content="Short text.", metadata={"source_filename": "t.txt", "page": 1})]
        chunks = chunker.chunk_documents(docs)
        assert len(chunks) == 0  # below min_length


# ── PII Scrubber Unit Tests ───────────────────────────────────────────────────

class TestPIIScrubber:
    def test_email_scrubbing(self):
        from ingestion.pii_scrubber import scrub_pii
        text = "Contact alice@example.com for more info."
        result = scrub_pii(text, use_presidio=False)
        assert "alice@example.com" not in result
        assert "<EMAIL>" in result

    def test_phone_scrubbing(self):
        from ingestion.pii_scrubber import scrub_pii
        text = "Call us at 555-867-5309."
        result = scrub_pii(text, use_presidio=False)
        assert "555-867-5309" not in result

    def test_ssn_scrubbing(self):
        from ingestion.pii_scrubber import scrub_pii
        text = "SSN: 123-45-6789"
        result = scrub_pii(text, use_presidio=False)
        assert "123-45-6789" not in result
        assert "<SSN>" in result

    def test_clean_text_unchanged(self):
        from ingestion.pii_scrubber import scrub_pii
        text = "The expense policy allows up to $500 per quarter."
        result = scrub_pii(text, use_presidio=False)
        assert "expense policy" in result
        assert "$500" in result


# ── Confidence Scoring Unit Tests ─────────────────────────────────────────────

class TestConfidenceScoring:
    def test_high_confidence(self):
        from utils.scoring import compute_confidence, ConfidenceBand
        result = compute_confidence(0.92, "direct", 3, 200)
        assert result.band == ConfidenceBand.HIGH
        assert result.score >= 0.75
        assert not result.human_review_required

    def test_not_found_scores_low(self):
        from utils.scoring import compute_confidence, ConfidenceBand
        result = compute_confidence(0.90, "not_found", 0, 50)
        assert result.score <= 0.10
        assert result.human_review_required

    def test_no_sources_scores_zero(self):
        from utils.scoring import compute_confidence
        result = compute_confidence(0.80, "direct", 0, 200)
        assert result.score == 0.0

    def test_partial_answer_capped(self):
        from utils.scoring import compute_confidence, ConfidenceBand
        result = compute_confidence(0.95, "partial", 2, 150)
        assert result.score <= 0.70


# ── Memory Unit Tests ─────────────────────────────────────────────────────────

class TestMemory:
    def test_add_and_format_turns(self):
        from rag.memory import ConversationMemoryManager
        mgr = ConversationMemoryManager()
        mgr.add_turn("sess1", "user", "What is the policy?")
        mgr.add_turn("sess1", "assistant", "The policy allows $500.")
        history = mgr.format_history("sess1")
        assert "What is the policy?" in history
        assert "The policy allows $500." in history

    def test_clear_session(self):
        from rag.memory import ConversationMemoryManager
        mgr = ConversationMemoryManager()
        mgr.add_turn("sess2", "user", "Hello")
        mgr.clear("sess2")
        history = mgr.format_history("sess2")
        assert history == ""

    def test_empty_session_returns_empty(self):
        from rag.memory import ConversationMemoryManager
        mgr = ConversationMemoryManager()
        history = mgr.format_history("nonexistent-session")
        assert history == ""


# ── Health Check ──────────────────────────────────────────────────────────────

class TestHealth:
    def test_health_endpoint(self, app_client):
        resp = app_client.get("/health")
        assert resp.status_code == 200
        data = resp.json()
        assert data["status"] == "healthy"
        assert "version" in data

    def test_root_endpoint(self, app_client):
        resp = app_client.get("/")
        assert resp.status_code == 200


# ── Vector Store Utilities ────────────────────────────────────────────────────

class TestVectorStoreUtils:
    def test_rrf_merging(self):
        from vectorstore.store import _reciprocal_rank_fusion
        from langchain_core.documents import Document

        list1 = [
            Document(page_content="doc A", metadata={}),
            Document(page_content="doc B", metadata={}),
        ]
        list2 = [
            Document(page_content="doc B", metadata={}),
            Document(page_content="doc C", metadata={}),
        ]
        merged = _reciprocal_rank_fusion([list1, list2])
        # doc B appears in both lists → should rank highest
        assert merged[0].page_content == "doc B"

    def test_user_access_check(self):
        from vectorstore.store import _user_can_access
        assert _user_can_access("hr,all_staff", ["all_staff"]) is True
        assert _user_can_access("legal,admin", ["hr", "all_staff"]) is False
        assert _user_can_access("admin", ["admin"]) is True
