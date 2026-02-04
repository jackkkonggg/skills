---
name: convex-functions
description: Use when writing or editing Convex queries, mutations, actions, and HTTP endpoints with the correct syntax, validators, registration rules, and function references.
---

# Convex Functions

## Use New Function Syntax

- Always use the object-based syntax with `args`, `returns`, and `handler`.
- Always include `returns`; use `v.null()` for no return.

## Registration Rules

- Public: `query`, `mutation`, `action`.
- Internal: `internalQuery`, `internalMutation`, `internalAction`.
- Never register functions through `api` or `internal` objects.

## Validators

- Always include argument and return validators.
- Use `v.null()` for null returns (never rely on `undefined`).
- Prefer `v.int64()` over deprecated `v.bigint()`.
- Use `v.record()` for record types; `v.map()`/`v.set()` are not supported.

## Function References

- Use `api` for public functions and `internal` for internal functions from `convex/_generated/api`.
- File-based routing: `convex/example.ts` -> `api.example.f`.
- Nested file: `convex/messages/access.ts` -> `api.messages.access.h`.

## Calling Other Functions

- `ctx.runQuery` from query/mutation/action.
- `ctx.runMutation` from mutation/action.
- `ctx.runAction` from action.
- Only call an action from an action when crossing runtimes; otherwise use a shared helper.
- Use function references, not function values.
- If calling a function in the same file, add a return type annotation to avoid TS circularity.

## HTTP Endpoints

- Define in `convex/http.ts` with `httpRouter` and `httpAction`.
- Paths are registered exactly as provided (no prefixing).

## References

- Read `references/convex_rules.md` for the full rules and examples.
