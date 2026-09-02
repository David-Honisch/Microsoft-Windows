"""
Document Ingestion Routes
──────────────────────────
POST /documents/upload  — ingest a new document
GET  /documents/        — list all indexed documents (filtered by user groups)
DELETE /documents/{id}  — remove a document (editor/admin only)
"""
from __future__ import annotations

import logging
import tempfile
from pathlib import Path
from typing import Annotated

from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from pydantic import BaseModel

from api.auth import TokenData, get_current_user, require_role
from config import settings
from utils.audit import audit_logger

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/documents", tags=["Documents"])


class IngestResponse(BaseModel):
    doc_id: str
    filename: str
    doc_type: str
    access_groups: list[str]
    pages_parsed: int
    chunks_indexed: int
    file_hash: str
    ingested_at: str
    message: str


class DocumentMeta(BaseModel):
    doc_id: str
    source_filename: str
    doc_type: str
    access_groups: str
    uploaded_by: str
    ingestion_timestamp: str
    file_hash: str


@router.post(
    "/upload",
    response_model=IngestResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Upload and index a document",
)
async def upload_document(
    file: UploadFile = File(..., description="PDF, DOCX, PPTX, TXT, or MD file"),
    doc_type: str = Form("general", description="Document type: policy|sop|contract|manual|general"),
    access_groups: str = Form("all_staff", description="Comma-separated access groups"),
    current_user: Annotated[TokenData, Depends(require_role("editor"))] = None,
):
    # ── Validate file ──────────────────────────────────────────────────────
    suffix = Path(file.filename or "").suffix.lower()
    if suffix not in settings.ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
            detail=f"File type '{suffix}' not supported. Allowed: {settings.ALLOWED_EXTENSIONS}",
        )

    content = await file.read()
    if len(content) > settings.MAX_UPLOAD_SIZE_MB * 1024 * 1024:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail=f"File exceeds {settings.MAX_UPLOAD_SIZE_MB} MB limit.",
        )

    groups = [g.strip() for g in access_groups.split(",") if g.strip()]

    # ── Write to temp file and ingest ─────────────────────────────────────
    with tempfile.NamedTemporaryFile(suffix=suffix, delete=False) as tmp:
        tmp.write(content)
        tmp_path = Path(tmp.name)

    # Import here to avoid circular deps at module load time
    from api.dependencies import get_ingestor
    ingestor = get_ingestor()

    with audit_logger.timed_event(
        event_type="ingest",
        user_email=current_user.email,
        details={"filename": file.filename, "doc_type": doc_type},
        user_role=current_user.role,
        user_groups=current_user.groups,
    ):
        result = ingestor.ingest_file(
            file_path=tmp_path,
            doc_type=doc_type,
            access_groups=groups,
            uploaded_by=current_user.email,
        )

    tmp_path.unlink(missing_ok=True)

    return IngestResponse(**result, message=f"Successfully indexed {result['chunks_indexed']} chunks.")


@router.get(
    "/",
    response_model=list[DocumentMeta],
    summary="List all indexed documents visible to current user",
)
async def list_documents(
    current_user: Annotated[TokenData, Depends(get_current_user)] = None,
):
    from api.dependencies import get_store
    store = get_store()
    all_meta = store.get_all_doc_metadata()

    # Filter to documents accessible by current user
    visible = []
    for meta in all_meta:
        doc_groups = {g.strip() for g in meta.get("access_groups", "").split(",")}
        if current_user.role == "admin" or doc_groups & set(current_user.groups):
            visible.append(DocumentMeta(
                doc_id=meta.get("doc_id", ""),
                source_filename=meta.get("source_filename", ""),
                doc_type=meta.get("doc_type", "general"),
                access_groups=meta.get("access_groups", ""),
                uploaded_by=meta.get("uploaded_by", ""),
                ingestion_timestamp=meta.get("ingestion_timestamp", ""),
                file_hash=meta.get("file_hash", ""),
            ))
    return visible


@router.delete(
    "/{doc_id}",
    summary="Delete a document and all its chunks",
    status_code=status.HTTP_200_OK,
)
async def delete_document(
    doc_id: str,
    current_user: Annotated[TokenData, Depends(require_role("editor"))] = None,
):
    from api.dependencies import get_ingestor
    ingestor = get_ingestor()

    with audit_logger.timed_event(
        event_type="delete",
        user_email=current_user.email,
        details={"doc_id": doc_id},
        user_role=current_user.role,
        user_groups=current_user.groups,
    ):
        deleted = ingestor.delete_document(doc_id)

    return {"doc_id": doc_id, "chunks_deleted": deleted, "message": "Document removed."}
