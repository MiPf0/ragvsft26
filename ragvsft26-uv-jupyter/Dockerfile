# ============================================================
# Multi-stage Dockerfile: uv + Jupyter + Ollama access
# ============================================================
FROM python:3.12-slim AS base

# Prevent interactive prompts & set locale
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    tesseract-ocr \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
# Install uv (fast Python package manager)
# ============================================================
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# ============================================================
# Set up working directory
# ============================================================
WORKDIR /workspace

# ============================================================
# Create a virtual environment with uv
# Placed OUTSIDE /workspace (in /opt/venv) to prevent Docker
# Compose volume mounts from overwriting the installed packages.
# Docker caches this layer: if requirements.txt hasn't changed,
# the build skips this step entirely. If it has changed, uv makes 
# the rebuild extremely fast.
# ============================================================
RUN uv venv /opt/venv
ENV VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

# ============================================================
# Copy and install requirements
# We copy requirements.txt separately so Docker can cache this
# layer when requirements haven't changed.
# ============================================================
COPY requirements.txt /workspace/requirements.txt
RUN uv pip install -r /workspace/requirements.txt

# ============================================================
# Install the Jupyter kernel pointing at our venv
# ============================================================
RUN /opt/venv/bin/python -m ipykernel install --sys-prefix --name ragvsft26 --display-name "Python (ragvsft26)"

# ============================================================
# Expose Jupyter port
# ============================================================
EXPOSE 8888

# ============================================================
# Default command: start Jupyter Lab
# ============================================================
CMD ["jupyter", "lab", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--NotebookApp.token=${JUPYTER_TOKEN}", \
     "--notebook-dir=/workspace"]
