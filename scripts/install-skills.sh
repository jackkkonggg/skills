#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installing skills"

# All skills (user-authored + vendored) from this repo
echo ""
echo "--- All skills (jackkkonggg/skills) ---"
pnpm dlx skills add jackkkonggg/skills --skill '*' -g --agent claude-code -y || echo "  (failed, try manually)"

# Local skills that need direct copy (not discoverable by pnpm dlx skills add)
echo ""
echo "--- Local skills ---"
for skill in react-doctor; do
  if [ -d "$REPO_DIR/skills/$skill" ]; then
    mkdir -p "$HOME/.claude/skills/$skill"
    rsync -a --exclude='.pristine' --exclude='vendor.patch' "$REPO_DIR/skills/$skill/" "$HOME/.claude/skills/$skill/"
    echo "  Installed $skill"
  fi
done

# Extracted plugin commands (cc-*)
echo ""
echo "--- Extracted plugin commands ---"
for dir in "$REPO_DIR"/skills/cc-*; do
  if [ -d "$dir" ]; then
    name=$(basename "$dir")
    mkdir -p "$HOME/.claude/skills/$name"
    rsync -a --exclude='.pristine' --exclude='vendor.patch' "$dir/" "$HOME/.claude/skills/$name/"
    echo "  Installed $name"
  fi
done

echo ""
echo "==> Skill installation complete."
echo ""
echo "Plugins must be installed manually in Claude Code:"
echo "  /install-plugin everything-claude-code"
echo "  /install-plugin commit-commands@claude-plugins-official"
echo "  /install-plugin frontend-design@claude-plugins-official"
echo "  /install-plugin typescript-lsp@claude-plugins-official"
echo "  /install-plugin swift-lsp@claude-plugins-official"
