- set up with Claude Opus 4.6

## ✅ Project is live!

**Jupyter Lab** is running at: **[http://localhost:8888/lab?token=dev-token-ragvsft26](http://localhost:8888/lab?token=dev-token-ragvsft26)**

### What was created

| File                             | Purpose                                                     |
| -------------------------------- | ----------------------------------------------------------- |
| `.env`                           | Central config — Ollama URL, Jupyter token, default model   |
| `requirements.txt`               | All Python dependencies (ollama, langchain, chromadb, etc.) |
| `Dockerfile`                     | Image with Python 3.12, `uv`, Jupyter Lab, dedicated venv   |
| `docker-compose.yml`             | Container orchestration with persistent volumes             |
| `notebooks/00_ollama_test.ipynb` | Starter notebook to verify Ollama connectivity              |
| `scripts/install_package.sh`     | Install packages on the fly without rebuilding              |
| `scripts/shell.sh`               | Quick shell access into the container                       |
| `README.md`                      | Full documentation                                          |

### Developer-friendly design

- **Restart without rebuilding**: `docker compose up -d` — all installed packages persist in the `venv-data` volume
- **Install packages on the fly**: `./scripts/install_package.sh transformers` — no rebuild needed
- **Everything persists**: Notebooks, data, and code are bind-mounted to your project folder. Packages, caches, and Jupyter settings use named volumes
- **Only rebuild when `requirements.txt` changes**: `docker compose up --build -d`