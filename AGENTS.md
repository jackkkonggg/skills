# Skills — Agent Guide

## Reinstalling skills

Skills are installed globally into `~/.agents/skills/` with symlinks from agent-specific directories (e.g. `~/.claude/skills/`). They do not auto-update when the source repo changes.

**Always use `-g` (global).** Omitting it installs into the current project directory, which can replace repo source files with symlinks.

### Reinstall a single skill

```bash
pnpm dlx skills add jackkkonggg/skills --skill <skill-name> -g --agent universal antigravity claude-code -y
```

Example:

```bash
pnpm dlx skills add jackkkonggg/skills --skill react-gsap-best-practices -g --agent universal antigravity claude-code -y
```

### Reinstall all skills

```bash
pnpm dlx skills add jackkkonggg/skills --skill '*' -g --agent universal antigravity claude-code -y
```

### Check for updates and upgrade

```bash
pnpm dlx skills check
pnpm dlx skills update
```

### Verify installed skills

```bash
pnpm dlx skills list -g
```

## Available skills

| Skill | Purpose |
|---|---|
| `code-audit` | Structured codebase audit with auto-detection and prioritized findings |
| `convex-best-practices` | Convex backend rules (functions, schema, database, auth, scheduling) |
| `grammy-best-practices` | grammY Telegram bot framework patterns |
| `gsap-best-practices` | GSAP animation rules (core, timelines, ScrollTrigger, plugins, utils, performance) |
| `motion-react-best-practices` | Motion (`motion/react`) setup, variants, presence, layout, gestures, scroll |
| `react-gsap-best-practices` | React + GSAP lifecycle-safe patterns (`useGSAP`, `contextSafe`, SSR) |
| `typescript-clean-code` | Clean Code principles adapted for TypeScript |
