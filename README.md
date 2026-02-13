# Agent Skills

Production-oriented skill bundle for AI coding agents.

## Available Skills

- `convex-best-practices`: Combined Convex rules covering functions, runtime behavior, and schema design.
- `grammy-best-practices`: Combined grammY rules covering middleware, commands/interactions, sessions, conversations, transformers, files, scaling, reliability, and deployment operations.

## Install

```bash
npx skills add <owner>/<repo>
```

Install a specific skill:

```bash
npx skills add <owner>/<repo> --skill convex-best-practices
```

```bash
npx skills add <owner>/<repo> --skill grammy-best-practices
```

## Structure

```
skills/
  convex-best-practices/
    AGENTS.md
    SKILL.md
    agents/
      openai.yaml
    rules/
      convex-authentication.md
      convex-components.md
      convex-database.md
      convex-file-storage.md
      convex-functions.md
      convex-realtime.md
      convex-scheduling.md
      convex-search.md
  grammy-best-practices/
    AGENTS.md
    SKILL.md
    agents/
      openai.yaml
    rules/
      grammy-commands-interactions.md
      grammy-conversations.md
      grammy-core-middleware.md
      grammy-deployment-ops.md
      grammy-files-media.md
      grammy-reliability-flood.md
      grammy-scaling-runner.md
      grammy-sessions-state.md
      grammy-transformers-api.md
```
