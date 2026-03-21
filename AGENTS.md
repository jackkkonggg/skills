# Skills & Config Backup — Agent Guide

## Repository Layout

```
skills/          User-authored skills + extracted plugin commands
vendor/          External skill repos (shallow git submodules)
config/          IDE/tool config backups (Claude Code, Codex, Claude Desktop, Cursor)
scripts/         Automation (backup, restore, install, update)
```

## Reinstalling Skills

Skills install globally into `~/.agents/skills/` with symlinks from `~/.claude/skills/`.

**Always use `-g` (global).** Omitting it installs into the current project directory, which can replace repo source files with symlinks.

### Reinstall all user-authored skills

```bash
pnpm dlx skills add jackkkonggg/skills --skill '*' -g --agent universal antigravity claude-code -y
```

### Reinstall a single skill

```bash
pnpm dlx skills add jackkkonggg/skills --skill <skill-name> -g --agent universal antigravity claude-code -y
```

### Reinstall all vendor skills

```bash
./scripts/install-skills.sh
```

### Check for updates

```bash
pnpm dlx skills check
pnpm dlx skills update
```

### Update vendor submodules

```bash
./scripts/update.sh
```

## Available User-Authored Skills

| Skill | Purpose |
|---|---|
| `code-audit` | Structured codebase audit with auto-detection and prioritized findings |
| `convex-best-practices` | Convex backend rules (functions, schema, database, auth, scheduling) |
| `grammy-best-practices` | grammY Telegram bot framework patterns |
| `gsap-best-practices` | GSAP animation rules (core, timelines, ScrollTrigger, plugins, utils) |
| `motion-react-best-practices` | Motion React setup, variants, presence, layout, gestures, scroll |
| `react-gsap-best-practices` | React + GSAP lifecycle-safe patterns (useGSAP, contextSafe, SSR) |
| `typescript-clean-code` | Clean Code principles adapted for TypeScript |
| `react-doctor` | Scan React code for security, performance, correctness issues |

## Vendor Skill Sources

| Source Repo | Skills Provided |
|---|---|
| `vercel-labs/agent-skills` | react-best-practices, web-design-guidelines, composition-patterns |
| `vercel-labs/agent-browser` | agent-browser |
| `vercel-labs/skills` | find-skills |
| `vercel-labs/next-skills` | next-best-practices |
| `anthropics/skills` | frontend-design |
| `remotion-dev/skills` | remotion-best-practices |
| `shadcn/ui` | shadcn |
| `avdlee/swiftui-agent-skill` | swiftui-expert-skill |
| `avdlee/swift-concurrency-agent-skill` | swift-concurrency |
| `figma/mcp-server-guide` | create-design-system-rules, implement-design |
| `garrytan/gstack` | browse, qa, review, ship, retro, plan-ceo-review, plan-eng-review, setup-browser-cookies |

## Config Backup & Restore

```bash
./scripts/backup.sh    # system → repo (redacts secrets)
./scripts/restore.sh   # repo → system (substitutes secrets from .env)
```
