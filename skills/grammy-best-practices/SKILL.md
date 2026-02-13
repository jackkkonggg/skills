---
name: grammy-best-practices
description: Use when writing, reviewing, or refactoring grammY Telegram bots in Node.js/TypeScript (middleware, commands, filters, sessions, conversations, API transformers, files/media handling, flood-limit control, runner concurrency, webhooks, and deployment operations) to enforce production-safe patterns.
---

# grammY Best Practices

Apply these rules when working on grammY bot codebases.

## Rule loading order

1. Read `rules/grammy-core-middleware.md`.
2. Read `rules/grammy-commands-interactions.md`.
3. Read `rules/grammy-sessions-state.md`.
4. Read `rules/grammy-conversations.md`.
5. Read `rules/grammy-transformers-api.md`.
6. Read `rules/grammy-files-media.md`.
7. Read `rules/grammy-scaling-runner.md`.
8. Read `rules/grammy-reliability-flood.md`.
9. Read `rules/grammy-deployment-ops.md`.
10. Use `AGENTS.md` as a compact summary plus pointer.

## Enforcement policy

- Use recommendation-first language for style and performance guidance.
- Use strict language (`must` / `must not`) only for security, correctness, or runtime constraints.
- Prefer official grammY docs when resolving conflicts; update these rules when docs change.
