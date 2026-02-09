# Convex Rules (Database)

## Canonical docs

- https://docs.convex.dev/database
- https://docs.convex.dev/database/schemas
- https://docs.convex.dev/database/types
- https://docs.convex.dev/database/reading-data
- https://docs.convex.dev/database/reading-data/filters
- https://docs.convex.dev/database/reading-data/indexes
- https://docs.convex.dev/database/reading-data/indexes/indexes-and-query-perf
- https://docs.convex.dev/database/pagination
- https://docs.convex.dev/database/writing-data
- https://docs.convex.dev/database/advanced/system-tables

## Modeling and schema

- Use tables/documents idiomatically; avoid over-normalizing too early.
- Schema is optional during early prototyping, but strongly prefer `convex/schema.ts` before production.
- Keep `schemaValidation` enabled by default.
- Keep `strictTableNameTypes` enabled by default.
- Use `v.int64()` instead of deprecated `v.bigint()`.
- Use generated `Id` and `Doc` types from `./_generated/dataModel`.
- Remember system fields `_id` and `_creationTime` are always present.
- Treat `undefined` as non-storable in Convex values (with special behavior in `db.patch`).

## Query performance

- Prefer `.withIndex(...)` over `.filter(...)` for large or unbounded sets.
- `.filter(...)` is acceptable for bounded scans, small tables, or when index expressions cannot capture the condition.
- Avoid unbounded `.collect()` on large datasets; prefer `.take(n)` or `.paginate(...)`.
- Use `.unique()` only when at most one row should match.
- Set `.order("asc" | "desc")` explicitly when ordering matters.
- Remember `.filter(...)` scans rows in the query range and can hit read/scan limits at scale.

## Pagination and indexes

- Use `paginationOptsValidator` for paginated query arguments.
- Return `.paginate(args.paginationOpts)` results directly, or transform only the `page` field.
- Design compound indexes around real query prefixes and sort patterns.
- Avoid redundant prefix indexes unless needed for specific ordering semantics.
- Use staged indexes when large backfills would slow deploys.

## Mutations and writes

- Keep mutations transactional and focused on one intent.
- Use `ctx.db.patch` for shallow partial updates and `ctx.db.replace` for full replacement.
- Perform deletes in mutations (`ctx.db.delete`), not queries.
- Prefer idempotent write patterns where retries/conflicts are likely.

## Minimal example

```ts
import { query } from "./_generated/server";
import { v } from "convex/values";
import { paginationOptsValidator } from "convex/server";

export const listByAuthor = query({
  args: { author: v.string(), paginationOpts: paginationOptsValidator },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("messages")
      .withIndex("by_author", (q) => q.eq("author", args.author))
      .order("desc")
      .paginate(args.paginationOpts);
  },
});
```
