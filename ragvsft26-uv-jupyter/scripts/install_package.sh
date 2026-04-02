#!/usr/bin/env bash
# ============================================================
# Install a Python package into the running container
# WITHOUT rebuilding the image.
#
# Usage:
#   ./scripts/install_package.sh <package-name> [<package-name> ...]
#
# Examples:
#   ./scripts/install_package.sh transformers
#   ./scripts/install_package.sh "torch>=2.0" torchvision
# ============================================================

set -euo pipefail

CONTAINER_NAME="ragvsft26-jupyter"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <package-name> [<package-name> ...]"
    echo "Example: $0 transformers torch"
    exit 1
fi

echo "📦 Installing into running container: $*"
docker exec "$CONTAINER_NAME" uv pip install "$@"

echo ""
echo "✅ Done! Packages installed. Restart the Jupyter kernel to use them."
echo ""
echo "💡 To persist this across image rebuilds, add to requirements.txt:"
for pkg in "$@"; do
    echo "   $pkg"
done
