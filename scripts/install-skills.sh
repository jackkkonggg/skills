#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installing skills"

# User-authored skills (this repo)
echo ""
echo "--- User-authored skills (jackkkonggg/skills) ---"
pnpm dlx skills add jackkkonggg/skills --skill '*' -g --agent claude-code -y || echo "  (failed, try manually)"

# Vendor skills
echo ""
echo "--- Vendor skills ---"
declare -a SKILL_REPOS=(
  "vercel-labs/agent-skills"
  "vercel-labs/agent-browser"
  "vercel-labs/skills"
  "vercel-labs/next-skills"
  "anthropics/skills"
  "remotion-dev/skills"
  "shadcn/ui"
  "avdlee/swiftui-agent-skill"
  "avdlee/swift-concurrency-agent-skill"
  "figma/mcp-server-guide"
)

for repo in "${SKILL_REPOS[@]}"; do
  echo "  Installing from $repo..."
  pnpm dlx skills add "$repo" --skill '*' -g --agent claude-code -y 2>/dev/null || \
  pnpm dlx skills add "$repo" -g --agent claude-code -y 2>/dev/null || \
    echo "    (failed, try: pnpm dlx skills add $repo -g --agent claude-code -y)"
done

# gstack (uses git clone)
echo ""
echo "--- gstack ---"
if [ -d "$HOME/.claude/skills/gstack/.git" ]; then
  git -C "$HOME/.claude/skills/gstack" pull --depth 1 2>/dev/null || echo "  (pull failed)"
  echo "  Updated gstack"
else
  git clone --depth 1 https://github.com/garrytan/gstack.git "$HOME/.claude/skills/gstack" 2>/dev/null || echo "  (clone failed)"
  echo "  Cloned gstack"
fi
# Set up gstack symlinks
cd "$HOME/.claude/skills"
for sub in browse plan-ceo-review plan-eng-review qa retro review setup-browser-cookies ship; do
  if [ -d "gstack/$sub" ] && [ ! -L "$sub" ]; then
    ln -sf "gstack/$sub" "$sub"
    echo "  Symlinked $sub -> gstack/$sub"
  fi
done

# Local skills (react-doctor)
echo ""
echo "--- Local skills ---"
for skill in react-doctor; do
  if [ -d "$REPO_DIR/skills/$skill" ]; then
    mkdir -p "$HOME/.claude/skills/$skill"
    cp -r "$REPO_DIR/skills/$skill/"* "$HOME/.claude/skills/$skill/"
    echo "  Installed $skill"
  fi
done

# Extracted plugin commands
echo ""
echo "--- Extracted plugin commands ---"
for dir in "$REPO_DIR"/skills/cc-*; do
  if [ -d "$dir" ]; then
    name=$(basename "$dir")
    mkdir -p "$HOME/.claude/skills/$name"
    cp -r "$dir/"* "$HOME/.claude/skills/$name/"
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
