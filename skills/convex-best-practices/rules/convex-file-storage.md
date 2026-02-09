# Convex Rules (File Storage)

## Canonical docs

- https://docs.convex.dev/file-storage
- https://docs.convex.dev/file-storage/upload-files
- https://docs.convex.dev/file-storage/store-files
- https://docs.convex.dev/file-storage/serve-files
- https://docs.convex.dev/file-storage/delete-files
- https://docs.convex.dev/file-storage/file-metadata

## Core usage

- Use upload URLs and storage IDs as the primary file references in documents.
- Use `ctx.storage.getUrl(storageId)` to serve files.
- Delete storage objects when business records are deleted or replaced, if retention policy requires it.
- Generate upload URLs from mutations/actions and keep write authorization checks near URL issuance.
- Store externally fetched/generated files from actions when integrating third-party APIs.

## Metadata

- Prefer `ctx.db.system.get/query("_storage", ...)` for metadata access in queries and mutations.
- Treat `ctx.storage.getMetadata(...)` as legacy/deprecated guidance for new code.
- Store any app-specific file ownership metadata in normal app tables, not only in system metadata.

## Operational guidance

- Validate content type and size constraints before long-lived association to core entities.
- Keep storage access checks consistent with your auth model.

## Minimal example

```ts
import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

export const createUploadUrl = mutation({
  args: {},
  returns: v.string(),
  handler: async (ctx) => {
    return await ctx.storage.generateUploadUrl();
  },
});

export const getFileMetadata = query({
  args: { id: v.id("_storage") },
  handler: async (ctx, args) => {
    return await ctx.db.system.get("_storage", args.id);
  },
});
```
