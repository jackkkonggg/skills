# Convex Rules (Functions)

## Function guidelines

### New function syntax
- ALWAYS use the new function syntax for Convex functions.

```typescript
import { query } from "./_generated/server";
import { v } from "convex/values";
export const f = query({
    args: {},
    returns: v.null(),
    handler: async (ctx, args) => {
    // Function body
    },
});
```

### Http endpoint syntax
- HTTP endpoints are defined in `convex/http.ts` and require an `httpAction` decorator.

```typescript
import { httpRouter } from "convex/server";
import { httpAction } from "./_generated/server";
const http = httpRouter();
http.route({
    path: "/echo",
    method: "POST",
    handler: httpAction(async (ctx, req) => {
    const body = await req.bytes();
    return new Response(body, { status: 200 });
    }),
});
```

- HTTP endpoints are always registered at the exact path you specify in the `path` field.

### Validators
- Example array validator:

```typescript
import { mutation } from "./_generated/server";
import { v } from "convex/values";

export default mutation({
args: {
    simpleArray: v.array(v.union(v.string(), v.number())),
},
handler: async (ctx, args) => {
    //...
},
});
```

- Example schema with discriminated union validators:

```typescript
import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
    results: defineTable(
        v.union(
            v.object({
                kind: v.literal("error"),
                errorMessage: v.string(),
            }),
            v.object({
                kind: v.literal("success"),
                value: v.number(),
            }),
        ),
    )
});
```

- Always use `v.null()` when returning null.

```typescript
import { query } from "./_generated/server";
import { v } from "convex/values";

export const exampleQuery = query({
  args: {},
  returns: v.null(),
  handler: async (ctx, args) => {
      console.log("This query returns a null value");
      return null;
  },
});
```

- Valid Convex types and validators:

Convex Type  | TS/JS type  |  Example Usage         | Validator for argument validation and schemas  | Notes
----------- | ----------- | ---------------------- | ---------------------------------------------- | -----
Id          | string      | `doc._id`              | `v.id(tableName)`                              |
Null        | null        | `null`                 | `v.null()`                                     | `undefined` is not valid; use `null`.
Int64       | bigint      | `3n`                   | `v.int64()`                                    | BigInt only between -2^63 and 2^63-1.
Float64     | number      | `3.1`                  | `v.number()`                                   | NaN/Inf serialize as strings.
Boolean     | boolean     | `true`                 | `v.boolean()`                                  |
String      | string      | `"abc"`                | `v.string()`                                   | UTF-8, under 1MB.
Bytes       | ArrayBuffer | `new ArrayBuffer(8)`   | `v.bytes()`                                    | Under 1MB.
Array       | Array       | `[1, 3.2, "abc"]`      | `v.array(values)`                              | Max 8192 values.
Object      | Object      | `{a: "abc"}`           | `v.object({property: value})`                  | Plain objects only, max 1024 entries.
Record      | Record      | `{"a": "1", "b": "2"}` | `v.record(keys, values)`                       | Keys ASCII, nonempty, not starting with `$` or `_`.

### Function registration
- Use `internalQuery`, `internalMutation`, and `internalAction` for internal functions.
- Use `query`, `mutation`, and `action` for public functions.
- Do NOT register functions via `api` or `internal` objects.
- Always include argument and return validators for all functions.
- If a function doesn't return anything, include `returns: v.null()`.

### Function calling
- `ctx.runQuery` for queries.
- `ctx.runMutation` for mutations.
- `ctx.runAction` for actions.
- Only call actions from actions for runtime crossing; otherwise use shared helpers.
- Calls take `FunctionReference`, not a direct function value.
- If calling a function in the same file, annotate return type to avoid TS circularity.

```typescript
export const f = query({
  args: { name: v.string() },
  returns: v.string(),
  handler: async (ctx, args) => {
    return "Hello " + args.name;
  },
});

export const g = query({
  args: {},
  returns: v.null(),
  handler: async (ctx, args) => {
    const result: string = await ctx.runQuery(api.example.f, { name: "Bob" });
    return null;
  },
});
```

### Function references
- `api` for public functions.
- `internal` for internal functions.
- File-based routing for references.

### Api design
- Organize files with public functions under `convex/`.
- Use `query`, `mutation`, and `action` for public functions.
- Use `internalQuery`, `internalMutation`, and `internalAction` for internal functions.
