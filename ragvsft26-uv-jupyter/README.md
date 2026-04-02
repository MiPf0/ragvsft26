# 🧪 ragvsft26 — UV + Jupyter + Ollama (Docker)

A developer-friendly Docker environment for experimenting with local LLMs via Ollama, using Jupyter Lab and the `uv` package manager.

## ✨ Features

- **Jupyter Lab** accessible in your browser at `http://localhost:8888`
- **Local Ollama access** — talks to Ollama running on your host machine
- **`uv` package manager** — 10-100× faster than pip
- **Persistent everything** — notebooks, data, installed packages, and Jupyter config survive container restarts
- **No-rebuild workflow** — install new packages on the fly without rebuilding the image
- **Centralized config** — all URLs, tokens, and library lists in `.env` and `requirements.txt`

## 📁 Project Structure

```
ragvsft26-uv-jupyter/
├── .env                    # ← Ollama URLs, Jupyter token, project config
├── requirements.txt        # ← Python dependencies (edit & rebuild to persist)
├── Dockerfile              # ← Image definition (uv + jupyter + venv)
├── docker-compose.yml      # ← Container orchestration + volumes
├── .dockerignore
├── .gitignore
├── notebooks/
│   └── 00_ollama_test.ipynb  # ← Starter notebook to verify Ollama connectivity
├── scripts/
│   ├── install_package.sh  # ← Install packages without rebuilding
│   └── shell.sh            # ← Open a shell inside the container
└── data/                   # ← Persistent data directory (auto-created)
```

## 🚀 Quick Start

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [Ollama](https://ollama.ai) running on your host machine with at least one model pulled

```bash
# Make sure Ollama is running
ollama serve

# Pull a model (if you haven't already)
ollama pull llama3.2
```

### 1. Configure (optional)

Edit `.env` to match your setup:

```bash
# Change the default model
OLLAMA_DEFAULT_MODEL=llama3.2

# Change the Jupyter access token
JUPYTER_TOKEN=my-secret-token

# Change the port (if 8888 is taken)
JUPYTER_PORT=8889
```

### 2. Build & Start

```bash
# First time — builds the image and starts the container
docker compose up --build -d

# Subsequent times — just start (no rebuild needed)
docker compose up -d
```

### 3. Open Jupyter

Open your browser and go to:

```
http://localhost:8888/lab?token=dev-token-ragvsft26
```

(Replace the token if you changed `JUPYTER_TOKEN` in `.env`)

### 4. Run the test notebook

Open `notebooks/00_ollama_test.ipynb` and run all cells to verify Ollama connectivity.

## 🔧 Developer Workflow

### Install packages without rebuilding

```bash
# From your host machine
./scripts/install_package.sh transformers torch

# Or directly with docker exec
docker exec ragvsft26-jupyter uv pip install transformers
```

> **Note:** Packages installed this way persist across container **restarts** (thanks to the venv volume), but NOT across image **rebuilds**. Add important packages to `requirements.txt` for full persistence.

### Open a shell inside the container

```bash
./scripts/shell.sh
```

### Rebuild after changing requirements.txt

```bash
# Rebuild the image with new dependencies
docker compose up --build -d
```

### View logs

```bash
docker compose logs -f
```

### Stop the container (data is preserved)

```bash
docker compose down
```

### Full reset (removes volumes too)

```bash
docker compose down -v
```

## 📝 Using Ollama in Notebooks

All notebooks can load the config from `.env`:

```python
import os
from dotenv import load_dotenv

load_dotenv("/workspace/.env")

OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL")
OLLAMA_DEFAULT_MODEL = os.getenv("OLLAMA_DEFAULT_MODEL")
```

### With the `ollama` Python client

```python
from ollama import Client

client = Client(host=OLLAMA_BASE_URL)
response = client.chat(
    model=OLLAMA_DEFAULT_MODEL,
    messages=[{"role": "user", "content": "Hello!"}]
)
print(response["message"]["content"])
```

### With LangChain

```python
from langchain_ollama import ChatOllama

llm = ChatOllama(model=OLLAMA_DEFAULT_MODEL, base_url=OLLAMA_BASE_URL)
result = llm.invoke("What is RAG?")
print(result.content)
```

## 🗂️ Persistence Model

| What | Where | Survives Restart? | Survives Rebuild? |
|------|-------|:-:|:-:|
| Notebooks & code | `./` (bind mount) | ✅ | ✅ |
| Data files | `./data/` (bind mount) | ✅ | ✅ |
| `.env` config | `./` (bind mount) | ✅ | ✅ |
| Installed packages | `venv-data` volume | ✅ | ❌* |
| uv/pip cache | `uv-cache` volume | ✅ | ✅ |
| Jupyter settings | `jupyter-data` volume | ✅ | ✅ |

\* Packages from `requirements.txt` are always reinstalled during build. Add packages there for rebuild persistence.

## 🐛 Troubleshooting

### "Cannot reach Ollama"
- Make sure `ollama serve` is running on your host
- On **Mac/Windows**: `host.docker.internal` should work out of the box
- On **Linux**: Make sure `extra_hosts` is set in `docker-compose.yml` (it is by default)

### Port conflict
- Change `JUPYTER_PORT` in `.env` to a different port

### Packages missing after rebuild
- Add them to `requirements.txt` and rebuild with `docker compose up --build -d`
