# grammY Best Practices (Agent Rules)

This is the fast-path playbook. Use it to make decisions quickly, then consult the section files for exact patterns and examples.

## Non-negotiables

- Register `bot.catch(...)` on every production bot and classify `GrammyError` vs `HttpError`.
- `await` Bot API calls and other async work; do not leave unhandled promises in handlers.
- Use persistent session storage in production; do not rely on default in-memory storage.
- When using `@grammyjs/runner` with sessions, run `sequentialize(...)` before `session(...)`.
- Use a flood-control strategy (`auto-retry`, throttling, or both) for 429 resilience.
- Prefer retriable upload patterns; avoid fragile one-shot stream-only uploads when retries are possible.
- For webhooks, acknowledge quickly and offload long-running work from the request path.

## Core defaults

- Keep middleware stack explicit and ordered; install global middleware before route-specific handlers.
- Keep command and callback handlers narrow, then delegate side effects to dedicated helpers/services.
- Scope session keys deliberately (chat, user, or chat+user) based on state isolation needs.
- Use conversations for multi-step flows and keep exits/timeouts explicit.
- Use API transformers intentionally and document why each transformer exists.
- Use runner concurrency for throughput, then add sequential constraints where state races can happen.

## Operations defaults

- Treat webhook and long polling as deployment choices with different failure modes and shutdown semantics.
- Add graceful stop handlers (`SIGINT`, `SIGTERM`) for polling runners and process managers.
- Track retry/flood behavior and handler failures in logs/metrics with update IDs for traceability.

## Full references

- `rules/grammy-core-middleware.md`
- `rules/grammy-commands-interactions.md`
- `rules/grammy-sessions-state.md`
- `rules/grammy-conversations.md`
- `rules/grammy-transformers-api.md`
- `rules/grammy-files-media.md`
- `rules/grammy-scaling-runner.md`
- `rules/grammy-reliability-flood.md`
- `rules/grammy-deployment-ops.md`
