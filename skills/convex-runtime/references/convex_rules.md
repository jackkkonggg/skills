# Convex Rules (Runtime)

## Pagination
- Use `paginationOptsValidator` and `.paginate()`.
- `paginationOpts` has `numItems` (number) and `cursor` (string or null).
- Paginated result includes `page`, `isDone`, `continueCursor`.

```ts
import { v } from "convex/values";
import { query, mutation } from "./_generated/server";
import { paginationOptsValidator } from "convex/server";
export const listWithExtraArg = query({
    args: { paginationOpts: paginationOptsValidator, author: v.string() },
    handler: async (ctx, args) => {
        return await ctx.db
        .query("messages")
        .withIndex("by_author", (q) => q.eq("author", args.author))
        .order("desc")
        .paginate(args.paginationOpts);
    },
});
```

## Full text search

```ts
const messages = await ctx.db
  .query("messages")
  .withSearchIndex("search_body", (q) =>
    q.search("body", "hello hi").eq("channel", "#general"),
  )
  .take(10);
```

## Query guidelines
- Do NOT use `filter`; use indexes with `withIndex`.
- Queries do NOT support `.delete()`; iterate and `ctx.db.delete`.
- Use `.unique()` for a single document result.
- For async iteration, use `for await (const row of query)`.
- Ordering defaults to `_creationTime` asc; use `.order("asc" | "desc")`.

## Mutation guidelines
- Use `ctx.db.replace` for full replacement (throws if missing).
- Use `ctx.db.patch` for shallow updates (throws if missing).

## Action guidelines
- Add `"use node";` when using Node built-ins.
- Never use `ctx.db` in actions.

## Scheduling guidelines
- Use `crons.interval` or `crons.cron` only.
- Crons take function references, not function values.
- Declare top-level `crons` and export default.
- Always import `internal` when referencing internal functions in crons.

```ts
import { cronJobs } from "convex/server";
import { internal } from "./_generated/api";
import { internalAction } from "./_generated/server";

const empty = internalAction({
  args: {},
  returns: v.null(),
  handler: async (ctx, args) => {
    console.log("empty");
  },
});

const crons = cronJobs();

crons.interval("delete inactive users", { hours: 2 }, internal.crons.empty, {});

export default crons;
```

## File storage guidelines
- Use `ctx.storage.getUrl()`; returns null if missing.
- Do NOT use deprecated `ctx.storage.getMetadata`.
- Query `_storage` via `ctx.db.system.get`.
- Storage items are `Blob` objects; convert to/from `Blob`.

```ts
import { query } from "./_generated/server";
import { Id } from "./_generated/dataModel";

type FileMetadata = {
    _id: Id<"_storage">;
    _creationTime: number;
    contentType?: string;
    sha256: string;
    size: number;
}

export const exampleQuery = query({
    args: { fileId: v.id("_storage") },
    returns: v.null(),
    handler: async (ctx, args) => {
        const metadata: FileMetadata | null = await ctx.db.system.get("_storage", args.fileId);
        console.log(metadata);
        return null;
    },
});
```
