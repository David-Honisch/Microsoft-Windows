"""
Enterprise RAG — Central Configuration
All settings resolved from environment variables with sensible defaults.
"""
from __future__ import annotations

import os
from enum import Enum
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


BASE_DIR = Path(__file__).parent


class LLMProvider(str, Enum):
    OPENAI = "openai"
    WATSONX = "watsonx"
    HUGGINGFACE = "huggingface"


class VectorStoreBackend(str, Enum):
    CHROMA = "chroma"
    PINECONE = "pinecone"


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=BASE_DIR / ".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # ── Application ──────────────────────────────────────────────────────────
    APP_NAME: str = "Enterprise RAG Knowledge Assistant"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = False
    SECRET_KEY: str = "change-me-in-production-use-32-char-random-string"
    ALLOWED_ORIGINS: list[str] = ["http://localhost:3000", "http://localhost:8501"]

    # ── LLM Provider ──────────────────────────────────────────────────────────
    LLM_PROVIDER: LLMProvider = LLMProvider.OPENAI

    # OpenAI
    OPENAI_API_KEY: str = ""
    OPENAI_MODEL: str = "gpt-4o"
    OPENAI_TEMPERATURE: float = 0.0
    OPENAI_MAX_TOKENS: int = 1500

    # Watsonx.ai
    WATSONX_API_KEY: str = ""
    WATSONX_PROJECT_ID: str = ""
    WATSONX_URL: str = "https://us-south.ml.cloud.ibm.com"
    WATSONX_MODEL_ID: str = "meta-llama/llama-3-70b-instruct"

    # ── Embedding Model ───────────────────────────────────────────────────────
    EMBEDDING_MODEL: str = "BAAI/bge-m3"          # local HuggingFace (no key needed)
    EMBEDDING_DEVICE: str = "cpu"                  # "cuda" if GPU available
    EMBEDDING_BATCH_SIZE: int = 32

    # ── Vector Store ──────────────────────────────────────────────────────────
    VECTOR_STORE_BACKEND: VectorStoreBackend = VectorStoreBackend.CHROMA
    CHROMA_PERSIST_DIR: Path = BASE_DIR / "data" / "chroma_db"

    PINECONE_API_KEY: str = ""
    PINECONE_INDEX_NAME: str = "enterprise-rag"
    PINECONE_ENVIRONMENT: str = "us-east-1"

    # ── Chunking ──────────────────────────────────────────────────────────────
    CHUNK_SIZE: int = 512
    CHUNK_OVERLAP: int = 64
    CHUNK_MIN_LENGTH: int = 50          # discard chunks shorter than this

    # ── Retrieval ─────────────────────────────────────────────────────────────
    RETRIEVAL_TOP_K: int = 20           # initial ANN recall
    RERANK_TOP_N: int = 5              # after cross-encoder re-ranking
    SIMILARITY_THRESHOLD: float = 0.30  # cosine; lower = broader recall
    USE_HYBRID_SEARCH: bool = True
    USE_RERANKER: bool = True
    RERANKER_MODEL: str = "cross-encoder/ms-marco-MiniLM-L-6-v2"

    # ── Token Budget ──────────────────────────────────────────────────────────
    MAX_CONTEXT_TOKENS: int = 3000     # tokens reserved for retrieved context
    MAX_HISTORY_TURNS: int = 3         # conversation turns to include

    # ── Storage ───────────────────────────────────────────────────────────────
    UPLOAD_DIR: Path = BASE_DIR / "data" / "uploads"
    MAX_UPLOAD_SIZE_MB: int = 50
    ALLOWED_EXTENSIONS: set[str] = {".pdf", ".docx", ".txt", ".md", ".pptx"}

    # ── Auth / RBAC ───────────────────────────────────────────────────────────
    JWT_ALGORITHM: str = "HS256"
    JWT_EXPIRE_MINUTES: int = 480      # 8-hour working day
    # Roles: admin > editor > viewer
    DEFAULT_ROLE: str = "viewer"

    # ── Audit Logging ─────────────────────────────────────────────────────────
    AUDIT_LOG_FILE: Path = BASE_DIR / "data" / "audit.jsonl"
    LOG_LEVEL: str = "INFO"

    # ── Confidence ────────────────────────────────────────────────────────────
    CONFIDENCE_HIGH_THRESHOLD: float = 0.75
    CONFIDENCE_LOW_THRESHOLD: float = 0.50  # below → flag for human review

    # ── Redis (optional caching) ───────────────────────────────────────────────
    REDIS_URL: str = ""                # e.g. redis://localhost:6379/0
    CACHE_TTL_SECONDS: int = 3600


settings = Settings()
