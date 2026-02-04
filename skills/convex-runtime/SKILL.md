---
name: convex-runtime
description: Use when applying Convex runtime guidelines for queries, mutations, actions, pagination, full-text search, scheduling, and storage, especially in data access logic or background jobs.
---

# Convex Runtime

## Queries

- Do not use `.filter()`; use indexes with `.withIndex()`.
- Use `.unique()` when you expect a single document and want an error on multiple.
- Queries cannot call `.delete()`; collect and delete manually.
- Use `for await (const row of query)` for async iteration, not `.collect()` or `.take(n)`.
- Default order is `_creationTime` asc; specify `.order("asc" | "desc")` as needed.

## Mutations

- Use `ctx.db.replace` for full replacement (throws if missing).
- Use `ctx.db.patch` for shallow updates (throws if missing).

## Actions

- Add "use node" at the top if using Node built-ins.
- Never use `ctx.db` in actions.

## Pagination

- Use `paginationOptsValidator` and `.paginate()`.
- Returned object has `page`, `isDone`, and `continueCursor`.

## Full Text Search

- Use `.withSearchIndex()` with `.search()` and any extra filters in the same chain.

## Scheduling

- Use `crons.interval` or `crons.cron`; avoid hourly/daily/weekly helpers.
- Crons take function references (not function values).
- Always import `internal` when referencing internal functions in crons.

## Storage

- Use `ctx.storage.getUrl()` to get signed URLs.
- Do not use deprecated `ctx.storage.getMetadata`; query `_storage` via `ctx.db.system.get`.
- Treat storage items as `Blob` and convert to/from `Blob`.

## References

- Read `references/convex_rules.md` for the full rules and examples.
