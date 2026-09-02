"""
Enterprise RAG — Streamlit Frontend
─────────────────────────────────────
Full-featured UI with:
  - Login / logout (JWT-backed)
  - Document upload with progress feedback
  - Multi-turn conversational Q&A with citation display
  - Confidence score badge and human-review flag
  - Document management panel
  - Admin audit log viewer

Run with:
    streamlit run frontend/app.py
"""
from __future__ import annotations

import json
import time
from pathlib import Path
from typing import Any

import requests
import streamlit as st

# ── Configuration ─────────────────────────────────────────────────────────────
API_BASE = "http://localhost:8000/api/v1"
PAGE_TITLE = "Enterprise RAG — Knowledge Assistant"
ACCENT = "#3b82d4"

st.set_page_config(
    page_title=PAGE_TITLE,
    page_icon="🔍",
    layout="wide",
    initial_sidebar_state="expanded",
)

# ── Session State Defaults ────────────────────────────────────────────────────
for key, default in {
    "token": None,
    "user": None,
    "messages": [],
    "session_id": None,
    "page": "chat",
}.items():
    if key not in st.session_state:
        st.session_state[key] = default


# ── API Helpers ───────────────────────────────────────────────────────────────

def api_headers() -> dict:
    return {"Authorization": f"Bearer {st.session_state.token}"}


def api_post(path: str, **kwargs) -> requests.Response:
    return requests.post(f"{API_BASE}{path}", headers=api_headers(), **kwargs)


def api_get(path: str, **kwargs) -> requests.Response:
    return requests.get(f"{API_BASE}{path}", headers=api_headers(), **kwargs)


def api_delete(path: str) -> requests.Response:
    return requests.delete(f"{API_BASE}{path}", headers=api_headers())


def login(email: str, password: str) -> bool:
    try:
        resp = requests.post(
            f"{API_BASE}/auth/token",
            data={"username": email, "password": password},
        )
        if resp.status_code == 200:
            data = resp.json()
            st.session_state.token = data["access_token"]
            st.session_state.user = {
                "email": data["user_email"],
                "name": data["user_name"],
                "role": data["role"],
                "groups": data["groups"],
            }
            return True
    except requests.ConnectionError:
        st.error("Cannot connect to API. Is the backend running on port 8000?")
    return False


# ── Confidence Badge ──────────────────────────────────────────────────────────

def confidence_badge(score: float, band: str) -> str:
    colours = {"high": "#1a7f37", "medium": "#d97706", "low": "#d73a49"}
    colour = colours.get(band, "#57606a")
    pct = int(score * 100)
    return (
        f'<span style="background:{colour};color:#fff;padding:2px 8px;'
        f'border-radius:10px;font-size:12px;font-weight:600;">'
        f"{band.upper()} {pct}%</span>"
    )


# ── Login Page ────────────────────────────────────────────────────────────────

def render_login():
    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.markdown(
            "<h1 style='text-align:center;color:#3b82d4;'>🔍 Enterprise RAG</h1>"
            "<p style='text-align:center;color:#57606a;'>Knowledge Assistant</p>",
            unsafe_allow_html=True,
        )
        st.markdown("---")

        with st.form("login_form"):
            email = st.text_input("Email", placeholder="admin@acme.com")
            password = st.text_input("Password", type="password", placeholder="••••••••")
            submitted = st.form_submit_button("Sign In", use_container_width=True)

        if submitted:
            with st.spinner("Authenticating..."):
                if login(email, password):
                    st.success(f"Welcome, {st.session_state.user['name']}!")
                    time.sleep(0.5)
                    st.rerun()
                else:
                    st.error("Invalid email or password.")

        st.markdown(
            "<div style='text-align:center;font-size:12px;color:#57606a;margin-top:16px;'>"
            "Demo accounts: admin@acme.com / admin123 &nbsp;|&nbsp; "
            "hr@acme.com / editor123 &nbsp;|&nbsp; employee@acme.com / viewer123"
            "</div>",
            unsafe_allow_html=True,
        )


# ── Sidebar ───────────────────────────────────────────────────────────────────

def render_sidebar():
    user = st.session_state.user
    st.sidebar.markdown(
        f"**{user['name']}**  \n"
        f"<span style='color:#57606a;font-size:12px;'>{user['email']}</span>  \n"
        f"<span style='background:#e8f0fe;color:#3b82d4;padding:2px 8px;"
        f"border-radius:10px;font-size:11px;font-weight:600;'>{user['role'].upper()}</span>",
        unsafe_allow_html=True,
    )
    st.sidebar.markdown("---")

    pages = {"💬 Chat": "chat", "📄 Documents": "documents"}
    if user["role"] == "admin":
        pages["🔒 Audit Log"] = "audit"

    for label, page_key in pages.items():
        if st.sidebar.button(label, use_container_width=True, key=f"nav_{page_key}"):
            st.session_state.page = page_key
            st.rerun()

    st.sidebar.markdown("---")
    st.sidebar.markdown(
        f"**Groups:** `{'`, `'.join(user['groups'])}`  \n"
        f"<span style='font-size:11px;color:#57606a;'>"
        f"Documents are filtered to your access groups.</span>",
        unsafe_allow_html=True,
    )

    if st.sidebar.button("Sign Out", use_container_width=True):
        for key in ["token", "user", "messages", "session_id", "page"]:
            st.session_state[key] = None if key != "messages" else []
        st.session_state.page = "chat"
        st.rerun()


# ── Chat Page ─────────────────────────────────────────────────────────────────

def render_chat():
    st.markdown("## 💬 Ask the Knowledge Assistant")
    st.markdown(
        "<p style='color:#57606a;'>Ask questions about your enterprise documents. "
        "All answers are grounded in retrieved content with citations.</p>",
        unsafe_allow_html=True,
    )

    # ── Session controls ──────────────────────────────────────────────────
    col1, col2, col3 = st.columns([3, 1, 1])
    with col2:
        if st.session_state.session_id:
            st.caption(f"Session: `{st.session_state.session_id[:8]}…`")
    with col3:
        if st.button("🗑 New Session"):
            if st.session_state.session_id:
                api_delete(f"/query/history/{st.session_state.session_id}")
            st.session_state.messages = []
            st.session_state.session_id = None
            st.rerun()

    # ── Message history ───────────────────────────────────────────────────
    chat_container = st.container()
    with chat_container:
        for msg in st.session_state.messages:
            with st.chat_message(msg["role"]):
                if msg["role"] == "user":
                    st.markdown(msg["content"])
                else:
                    _render_assistant_message(msg)

    # ── Input ─────────────────────────────────────────────────────────────
    if question := st.chat_input("Ask a question about your documents…"):
        # Add user message
        st.session_state.messages.append({"role": "user", "content": question})

        with st.chat_message("user"):
            st.markdown(question)

        with st.chat_message("assistant"):
            with st.spinner("Searching knowledge base…"):
                import uuid as _uuid
                if not st.session_state.session_id:
                    st.session_state.session_id = str(_uuid.uuid4())

                payload = {
                    "question": question,
                    "session_id": st.session_state.session_id,
                    "use_hyde": True,
                }
                try:
                    resp = api_post("/query/chat", json=payload)
                    if resp.status_code == 200:
                        data = resp.json()
                        st.session_state.messages.append({
                            "role": "assistant",
                            **data,
                        })
                        _render_assistant_message(data)
                    else:
                        err_msg = resp.json().get("detail", "API error")
                        st.error(f"Error: {err_msg}")
                except requests.ConnectionError:
                    st.error("Cannot connect to API backend.")


def _render_assistant_message(msg: dict):
    """Render a structured RAG response with citations and confidence."""
    answer = msg.get("answer", msg.get("content", ""))
    confidence = msg.get("confidence", 0.0)
    band = msg.get("confidence_band", "low")
    answer_type = msg.get("answer_type", "")
    citations = msg.get("citations", [])
    follow_ups = msg.get("follow_up_suggestions", [])
    review_required = msg.get("human_review_required", False)

    # Answer text
    st.markdown(answer)

    # Confidence badge
    badge_html = confidence_badge(confidence, band)
    sources = msg.get("sources_used", 0)
    st.markdown(
        f"{badge_html} &nbsp; <span style='color:#57606a;font-size:12px;'>"
        f"{sources} source(s) retrieved</span>",
        unsafe_allow_html=True,
    )

    # Human review warning
    if review_required:
        st.warning(
            f"⚠️ **Human review recommended.** "
            f"{msg.get('review_reason', 'Low confidence answer.')}"
        )

    # Citations
    if citations:
        with st.expander(f"📚 View {len(citations)} Source(s)", expanded=False):
            for i, c in enumerate(citations, 1):
                if isinstance(c, dict):
                    doc_title = c.get("doc_title", "Unknown")
                    page = c.get("page", "?")
                    section = c.get("section", "N/A")
                    rel_score = c.get("relevance_score", 0.0)
                else:
                    doc_title = getattr(c, "doc_title", "Unknown")
                    page = getattr(c, "page", "?")
                    section = getattr(c, "section", "N/A")
                    rel_score = getattr(c, "relevance_score", 0.0)

                st.markdown(
                    f"**[{i}]** `{doc_title}` — Page **{page}** — *{section}*  "
                    f"<span style='color:#57606a;font-size:11px;'>"
                    f"Relevance: {rel_score:.0%}</span>",
                    unsafe_allow_html=True,
                )

    # Follow-up suggestions
    if follow_ups:
        st.markdown(
            "<p style='color:#57606a;font-size:12px;margin-top:8px;'>"
            "💡 <strong>Suggested follow-up questions:</strong></p>",
            unsafe_allow_html=True,
        )
        for fq in follow_ups[:2]:
            st.markdown(f"→ *{fq}*")

    # Feedback
    col_a, col_b, _ = st.columns([1, 1, 8])
    with col_a:
        if st.button("👍", key=f"up_{id(msg)}"):
            _submit_feedback(msg, 5)
    with col_b:
        if st.button("👎", key=f"down_{id(msg)}"):
            _submit_feedback(msg, 1)


def _submit_feedback(msg: dict, rating: int):
    payload = {
        "session_id": st.session_state.session_id or "",
        "question": "",
        "answer": msg.get("answer", ""),
        "rating": rating,
        "comment": "",
    }
    api_post("/query/feedback", json=payload)
    st.toast("Feedback recorded!", icon="✅")


# ── Documents Page ────────────────────────────────────────────────────────────

def render_documents():
    st.markdown("## 📄 Document Management")
    user = st.session_state.user

    # ── Upload section ────────────────────────────────────────────────────
    if user["role"] in ("editor", "admin"):
        st.markdown("### Upload New Document")
        with st.form("upload_form", clear_on_submit=True):
            uploaded_file = st.file_uploader(
                "Choose a file",
                type=["pdf", "docx", "pptx", "txt", "md"],
                help="Supported formats: PDF, DOCX, PPTX, TXT, Markdown",
            )
            col1, col2 = st.columns(2)
            with col1:
                doc_type = st.selectbox(
                    "Document Type",
                    ["general", "policy", "sop", "contract", "manual"],
                )
            with col2:
                access_groups_input = st.text_input(
                    "Access Groups (comma-separated)",
                    value="all_staff",
                    help="e.g. hr,all_staff or legal,admin",
                )
            submit_btn = st.form_submit_button("Upload & Index", use_container_width=True)

        if submit_btn and uploaded_file:
            with st.spinner(f"Ingesting {uploaded_file.name}..."):
                try:
                    resp = api_post(
                        "/documents/upload",
                        files={"file": (uploaded_file.name, uploaded_file.getvalue(), uploaded_file.type)},
                        data={"doc_type": doc_type, "access_groups": access_groups_input},
                    )
                    if resp.status_code == 201:
                        result = resp.json()
                        st.success(
                            f"✅ **{result['filename']}** indexed successfully — "
                            f"{result['chunks_indexed']} chunks from {result['pages_parsed']} pages."
                        )
                    else:
                        st.error(f"Upload failed: {resp.json().get('detail', 'Unknown error')}")
                except requests.ConnectionError:
                    st.error("Cannot connect to API backend.")

    st.markdown("---")

    # ── Document list ─────────────────────────────────────────────────────
    st.markdown("### Indexed Documents")
    try:
        resp = api_get("/documents/")
        if resp.status_code == 200:
            docs = resp.json()
            if not docs:
                st.info("No documents indexed yet. Upload your first document above.")
            else:
                for doc in docs:
                    col1, col2, col3, col4 = st.columns([4, 2, 2, 1])
                    with col1:
                        st.markdown(f"📄 **{doc['source_filename']}**")
                        st.caption(f"ID: `{doc['doc_id'][:8]}…`")
                    with col2:
                        st.markdown(
                            f"<span style='background:#e8f0fe;color:#3b82d4;padding:2px 8px;"
                            f"border-radius:10px;font-size:11px;'>{doc['doc_type'].upper()}</span>",
                            unsafe_allow_html=True,
                        )
                    with col3:
                        st.caption(f"Groups: {doc['access_groups']}")
                        st.caption(f"By: {doc['uploaded_by']}")
                    with col4:
                        if user["role"] in ("editor", "admin"):
                            if st.button("🗑", key=f"del_{doc['doc_id']}", help="Delete document"):
                                del_resp = api_delete(f"/documents/{doc['doc_id']}")
                                if del_resp.status_code == 200:
                                    st.toast("Document deleted.", icon="🗑")
                                    st.rerun()
                    st.markdown("---")
        else:
            st.error("Failed to load documents.")
    except requests.ConnectionError:
        st.error("Cannot connect to API backend.")


# ── Audit Log Page ────────────────────────────────────────────────────────────

def render_audit():
    st.markdown("## 🔒 Audit Log")
    st.caption("All system events — queries, ingestions, deletions, logins.")

    try:
        resp = api_get("/admin/audit-log?limit=100")
        if resp.status_code == 200:
            events = resp.json()
            if not events:
                st.info("No audit events recorded yet.")
            else:
                for event in events:
                    colour = "#e6f4ea" if event.get("outcome") == "success" else "#fde8c8"
                    latency = event.get("latency_ms", 0)
                    details = event.get("details", {})
                    st.markdown(
                        f"<div style='background:{colour};border-radius:6px;padding:10px 14px;margin-bottom:8px;'>"
                        f"<strong>{event.get('event_type', '').upper()}</strong> &nbsp; "
                        f"<span style='color:#57606a;font-size:12px;'>{event.get('timestamp', '')[:19]}</span> &nbsp; "
                        f"<code>{event.get('user_email', '')}</code> &nbsp; "
                        f"<span style='color:#57606a;font-size:12px;'>{latency}ms</span><br>"
                        f"<span style='font-size:12px;color:#1f2328;'>{json.dumps(details)[:200]}</span>"
                        f"</div>",
                        unsafe_allow_html=True,
                    )
        elif resp.status_code == 403:
            st.error("Admin access required to view audit log.")
        else:
            st.error("Failed to load audit log.")
    except requests.ConnectionError:
        st.error("Cannot connect to API backend.")


# ── Main App ──────────────────────────────────────────────────────────────────

def main():
    if not st.session_state.token:
        render_login()
        return

    render_sidebar()

    page = st.session_state.page
    if page == "chat":
        render_chat()
    elif page == "documents":
        render_documents()
    elif page == "audit":
        render_audit()


if __name__ == "__main__":
    main()
