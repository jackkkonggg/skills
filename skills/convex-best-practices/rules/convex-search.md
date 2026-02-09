# Convex Rules (Search)

## Canonical docs

- https://docs.convex.dev/search
- https://docs.convex.dev/search/text-search
- https://docs.convex.dev/search/vector-search

## Full text search

- Define search indexes in schema with `.searchIndex(...)`.
- Query full text search with `.withSearchIndex(...)`.
- Put as many constraints as possible into search/index expressions for performance.
- Use post-search `.filter(...)` only when conditions cannot be represented in the search expression.
- Expect full-text results in relevance order (not arbitrary sortable order).

## Vector search

- Run vector search only in actions using `ctx.vectorSearch(...)`.
- Keep embedding dimensions aligned with vector index configuration.
- Load returned IDs explicitly via query/mutation after vector search.
- Prefer filtering inside `vectorSearch` when possible to reduce downstream work.
- Remember vector search is not available in queries/mutations.

## Result handling

- Keep search result limits bounded.
- Preserve relevance ordering semantics when mapping or joining result documents.

## Minimal example

```ts
import { query, action } from "./_generated/server";
import { v } from "convex/values";

export const searchMessages = query({
  args: { q: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("messages")
      .withSearchIndex("search_body", (q) => q.search("body", args.q))
      .take(10);
  },
});

export const semanticSearch = action({
  args: { embedding: v.array(v.float64()) },
  handler: async (ctx, args) => {
    return await ctx.vectorSearch("docs", "by_embedding", {
      vector: args.embedding,
      limit: 8,
    });
  },
});
```
