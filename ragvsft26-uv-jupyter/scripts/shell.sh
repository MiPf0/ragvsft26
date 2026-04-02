#!/usr/bin/env bash
# ============================================================
# Open a bash shell inside the running Jupyter container.
#
# Usage:
#   ./scripts/shell.sh
# ============================================================

set -euo pipefail

CONTAINER_NAME="ragvsft26-jupyter"

echo "🐚 Opening shell in $CONTAINER_NAME..."
docker exec -it "$CONTAINER_NAME" bash
