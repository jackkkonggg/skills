#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

echo "==> Updating vendor submodules (shallow)"
git submodule update --init --remote --depth 1
echo "  Done."

echo ""
echo "==> Syncing vendor skills"
bash "$REPO_DIR/scripts/vendor-sync.sh"

echo ""
echo "==> Backing up configs"
bash "$REPO_DIR/scripts/backup.sh"

echo ""
echo "==> Summary"
git status --short
echo ""
echo "Review changes with 'git diff', then commit when ready."
