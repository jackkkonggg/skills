# Convex Rules (Functions)

## Canonical docs

- https://docs.convex.dev/functions
- https://docs.convex.dev/functions/query-functions
- https://docs.convex.dev/functions/mutation-functions
- https://docs.convex.dev/functions/actions
- https://docs.convex.dev/functions/http-actions
- https://docs.convex.dev/functions/internal-functions
- https://docs.convex.dev/functions/runtimes
- https://docs.convex.dev/functions/validation

## Function registration and visibility

- Use `query`, `mutation`, and `action` for public functions.
- Use `internalQuery`, `internalMutation`, and `internalAction` for server-only entrypoints.
- Prefer internal functions for business logic that clients must not call directly.

## Validator policy

- Public queries, mutations, and actions must define `args` validators, including `args: {}` when no arguments are expected.
- Internal functions should usually define `args` validators, but may omit them for trusted, complex payloads passed only between server functions.
- Prefer `returns` validators for API boundary clarity, security hardening, and strong inferred return types.
- If intentionally returning no value, prefer `returns: v.null()` and return `null`.

## Function references and calls

- Use generated references from `./_generated/api`: `api` for public functions and `internal` for internal functions.
- Use `ctx.runQuery`, `ctx.runMutation`, and `ctx.runAction` with function references, not function values.
- Prefer shared helper functions over action-to-action calls in the same runtime.
- If TypeScript hits circular inference while calling a function in the same module, add an explicit return type annotation.

## Runtime and execution semantics

- Queries and mutations must remain deterministic.
- Actions may have side effects and are not automatically retried.
- Prefer calling mutations from clients and scheduling actions from mutations for durable intent capture.
- Await all promises to avoid dropped async work and hidden errors.

## Node runtime ("use node")

- Use `"use node";` only for action files that need Node APIs or unsupported npm packages.
- Files with `"use node";` must not contain queries or mutations.
- Files without `"use node";` must not import `"use node"` files.

## HTTP actions

- Define routes in `convex/http.ts` with `httpRouter()` and `http.route(...)`.
- Implement HTTP handlers with `httpAction(...)`.
- HTTP actions do not support Convex `args` validators; parse and validate request payloads explicitly.
- Keep HTTP actions thin: parse request, call Convex functions, and return `Response`.
- Remember that HTTP action request/response body size is limited (20MB at time of writing).

## Minimal examples

```ts
import { query, internalMutation } from "./_generated/server";
import { v } from "convex/values";

export const publicList = query({
  args: {},
  returns: v.array(v.string()),
  handler: async () => [],
});

export const applyInternalChange = internalMutation({
  args: { id: v.id("tasks"), done: v.boolean() },
  returns: v.null(),
  handler: async (ctx, args) => {
    await ctx.db.patch("tasks", args.id, { done: args.done });
    return null;
  },
});
```
