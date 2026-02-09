# Convex Best Practices (Agent Rules)

This is the fast-path playbook. Use it to make decisions quickly, then consult the section files for exact patterns and examples.

## Non-negotiables

- Validate inputs on all public function entrypoints.
- Keep database writes in mutations, not queries.
- Do database reads/writes from actions through `runQuery` and `runMutation`.
- Treat `"use node"` as an action-only boundary and keep imports runtime-safe.
- Parse and validate HTTP action payloads explicitly because Convex arg validators are not applied there.

## Function design defaults

- Use public functions as thin API surfaces and move sensitive business workflows behind internal functions.
- Favor return validators for clearer boundaries and safer type inference.
- Prefer shared helpers over chaining action-to-action calls in the same runtime.
- Reserve `runAction` for cross-runtime composition and special orchestration cases.

## Database

- Start with schema-flexible prototyping, then lock down schema before production.
- Design reads around indexes/search indexes first; treat `.filter` as a bounded fallback.
- Avoid large unbounded collections in reactive paths; page or cap result sizes.
- Keep strict schema/type options on unless there is a documented migration reason.

## Realtime

- Build UI data flow from queries so caching/reactivity stay automatic.
- Keep deterministic logic in query/mutation code paths so shared snapshots remain coherent.

## Authentication

- Assume every public function can be called by untrusted clients.
- Check identity and authorization near each protected data access.
- Keep privileged operations in internal APIs that user clients cannot invoke directly.

## Scheduling

- Use scheduler APIs for deferred jobs and cron APIs for recurring jobs.
- Remember mutation-triggered scheduling is transactional; action-triggered scheduling is not.
- Track and inspect scheduled jobs through system-table metadata when operations need auditability.

## File storage

- Treat storage IDs as primary references and URLs as derived artifacts.
- Read file metadata from system tables in normal data flows.
- Prefer modern metadata reads over legacy storage metadata helpers.

## Search

- Use full-text search indexes for keyword/typeahead experiences.
- Do semantic/vector retrieval in actions, then hydrate returned IDs explicitly.

## Components

- Treat components as isolated backend modules with explicit capability wiring.
- Pass only the minimum app surface area a component needs.

## Full references

- `rules/convex-functions.md`
- `rules/convex-database.md`
- `rules/convex-realtime.md`
- `rules/convex-authentication.md`
- `rules/convex-scheduling.md`
- `rules/convex-file-storage.md`
- `rules/convex-search.md`
- `rules/convex-components.md`
