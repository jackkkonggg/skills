# AI Agent Config & Skills Backup

Comprehensive backup of AI coding agent skills, plugin commands, and IDE configurations. One repo to restore the entire environment on a new machine.

## Quick Start

```bash
git clone --recurse-submodules --shallow-submodules git@github.com:jackkkonggg/skills.git
cd skills
./scripts/restore.sh       # restore IDE configs
./scripts/install-skills.sh # reinstall all skills
```

## Directory Structure

```
skills/          User-authored skills + extracted plugin commands
vendor/          External skill repos (git submodules, shallow)
config/          IDE/tool config backups
scripts/         Automation (backup, restore, install, update)
```

## User-Authored Skills

| Skill | Description |
|---|---|
| `code-audit` | Structured codebase audit with auto-detection and findings report |
| `convex-best-practices` | Convex backend rules (functions, schema, database, auth) |
| `grammy-best-practices` | grammY Telegram bot framework patterns |
| `gsap-best-practices` | GSAP animation rules (core, timelines, ScrollTrigger, plugins) |
| `motion-react-best-practices` | Motion React setup, variants, presence, gestures, scroll |
| `react-gsap-best-practices` | React + GSAP lifecycle-safe patterns |
| `typescript-clean-code` | Clean Code principles for TypeScript |
| `react-doctor` | Scan React code for security, performance, and correctness |

## Extracted Plugin Commands

Commands extracted from plugins as standalone skills:

### From commit-commands

| Skill | Description |
|---|---|
| `cc-commit` | Create a git commit |

## Vendor Skills (Submodules)

External skill repos tracked as shallow git submodules in `vendor/`:

| Submodule | Source | Skills |
|---|---|---|
| `vercel-agent-skills` | vercel-labs/agent-skills | react-best-practices, web-design-guidelines, composition-patterns |
| `vercel-agent-browser` | vercel-labs/agent-browser | agent-browser |
| `vercel-skills` | vercel-labs/skills | find-skills |
| `vercel-next-skills` | vercel-labs/next-skills | next-best-practices |
| `anthropic-skills` | anthropics/skills | frontend-design |
| `remotion-skills` | remotion-dev/skills | remotion-best-practices |
| `shadcn-ui` | shadcn/ui | shadcn |
| `swiftui-agent-skill` | avdlee/swiftui-agent-skill | swiftui-expert-skill |
| `swift-concurrency` | avdlee/swift-concurrency-agent-skill | swift-concurrency |
| `figma-mcp-server-guide` | figma/mcp-server-guide | create-design-system-rules, implement-design |
| `gstack` | garrytan/gstack | browse, qa, review, ship, retro, plan-ceo-review, plan-eng-review, setup-browser-cookies |
| `claude-plugins-official` | anthropics/claude-plugins-official | commit-commands, frontend-design, typescript-lsp, swift-lsp |

## Config Backups

| Config | Source | Notes |
|---|---|---|
| `config/claude-code/settings.json` | `~/.claude/settings.json` | Permissions, hooks, plugins |
| `config/claude-code/notify.sh` | `~/.claude/notify.sh` | Notification hook |
| `config/claude-code/statusline.sh` | `~/.claude/statusline.sh` | Status line display |
| `config/codex/config.toml.template` | `~/.codex/config.toml` | API key redacted |
| `config/codex/AGENTS.md` | `~/.codex/AGENTS.md` | Agent guidelines |
| `config/claude-desktop/claude_desktop_config.json` | Claude Desktop app | MCP server config |
| `config/cursor/mcp.json` | `~/.cursor/mcp.json` | MCP server config |
| `config/zed/settings.json` | `~/.config/zed/settings.json` | Editor settings |
| `config/zed/keymap.json` | `~/.config/zed/keymap.json` | Key bindings |
| `config/zed/themes/dark-modern.json` | `~/.config/zed/themes/dark-modern.json` | Custom Dark Modern theme |

## Scripts

| Script | Description |
|---|---|
| `scripts/update.sh` | Update all submodules + backup configs |
| `scripts/backup.sh` | Copy system configs into repo (redacts secrets) |
| `scripts/restore.sh` | Push repo configs to system locations |
| `scripts/install-skills.sh` | Reinstall all skills from sources |

## Workflows

**Periodic sync:**
```bash
./scripts/update.sh
git add -A && git commit -m "chore: sync configs and vendor skills"
```

**New machine setup:**
```bash
git clone --recurse-submodules --shallow-submodules git@github.com:jackkkonggg/skills.git
cd skills
cp .env.example .env  # add your API keys
./scripts/restore.sh
./scripts/install-skills.sh
```

**Add a new vendor skill:**
```bash
git submodule add --depth 1 https://github.com/org/repo.git vendor/repo-name
# Then update .gitmodules to add shallow = true
```
