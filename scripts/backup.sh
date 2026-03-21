#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="$REPO_DIR/config"

echo "==> Backing up configs into $CONFIG_DIR"

# Claude Code
mkdir -p "$CONFIG_DIR/claude-code"
cp "$HOME/.claude/settings.json" "$CONFIG_DIR/claude-code/settings.json" 2>/dev/null && echo "  settings.json" || echo "  settings.json (not found)"
cp "$HOME/.claude/notify.sh" "$CONFIG_DIR/claude-code/notify.sh" 2>/dev/null && echo "  notify.sh" || echo "  notify.sh (not found)"
cp "$HOME/.claude/statusline.sh" "$CONFIG_DIR/claude-code/statusline.sh" 2>/dev/null && echo "  statusline.sh" || echo "  statusline.sh (not found)"

# Codex
mkdir -p "$CONFIG_DIR/codex"
if [ -f "$HOME/.codex/config.toml" ]; then
  sed 's/CONTEXT7_API_KEY = "ctx7sk-[^"]*"/CONTEXT7_API_KEY = "${CONTEXT7_API_KEY}"/' \
    "$HOME/.codex/config.toml" > "$CONFIG_DIR/codex/config.toml.template"
  echo "  config.toml.template (redacted)"
else
  echo "  config.toml (not found)"
fi
cp "$HOME/.codex/AGENTS.md" "$CONFIG_DIR/codex/AGENTS.md" 2>/dev/null && echo "  AGENTS.md" || echo "  AGENTS.md (not found)"

# Claude Desktop
mkdir -p "$CONFIG_DIR/claude-desktop"
CLAUDE_DESKTOP="$HOME/Library/Application Support/Claude"
if [ -f "$CLAUDE_DESKTOP/claude_desktop_config.json" ]; then
  cp "$CLAUDE_DESKTOP/claude_desktop_config.json" "$CONFIG_DIR/claude-desktop/claude_desktop_config.json"
  echo "  claude_desktop_config.json"
fi

# Cursor
mkdir -p "$CONFIG_DIR/cursor"
cp "$HOME/.cursor/mcp.json" "$CONFIG_DIR/cursor/mcp.json" 2>/dev/null && echo "  mcp.json" || echo "  mcp.json (not found)"

# Zed
mkdir -p "$CONFIG_DIR/zed/themes"
cp "$HOME/.config/zed/settings.json" "$CONFIG_DIR/zed/settings.json" 2>/dev/null && echo "  settings.json" || echo "  settings.json (not found)"
cp "$HOME/.config/zed/keymap.json" "$CONFIG_DIR/zed/keymap.json" 2>/dev/null && echo "  keymap.json" || echo "  keymap.json (not found)"
cp "$HOME/.config/zed/themes/dark-modern.json" "$CONFIG_DIR/zed/themes/dark-modern.json" 2>/dev/null && echo "  themes/dark-modern.json" || echo "  themes/dark-modern.json (not found)"

# Verify no secrets leaked
if grep -rq "ctx7sk" "$CONFIG_DIR/" 2>/dev/null; then
  echo ""
  echo "WARNING: API key found in config files! Check redaction."
  exit 1
fi

echo ""
echo "==> Backup complete. Run 'git diff' to see changes."
