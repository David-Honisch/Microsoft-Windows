# ─────────────────────────────────────────────────────────────────────────────
# Enterprise RAG — Backend Dockerfile
# ─────────────────────────────────────────────────────────────────────────────
FROM python:3.11-slim AS base

# System deps: Tesseract OCR + build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    tesseract-ocr \
    tesseract-ocr-eng \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps in a separate layer for caching
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    python -m spacy download en_core_web_sm --quiet

# Copy source
COPY . .

# Create required directories
RUN mkdir -p data/uploads data/chroma_db

# Non-root user for security
RUN useradd -m -u 1000 raguser && chown -R raguser:raguser /app
USER raguser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]
