# Convex Rules (Scheduling)

## Canonical docs

- https://docs.convex.dev/scheduling
- https://docs.convex.dev/scheduling/scheduled-functions
- https://docs.convex.dev/scheduling/cron-jobs
- https://docs.convex.dev/database/advanced/system-tables

## Scheduled functions

- Use `ctx.scheduler.runAfter(...)` and `ctx.scheduler.runAt(...)` for deferred work.
- Mutation scheduling is atomic with mutation success.
- Action scheduling is not atomic; handle partial failure cases explicitly.
- Use `ctx.scheduler.cancel(...)` to cancel pending scheduled work.
- Auth context is not automatically propagated to scheduled function execution.
- Mutation-scheduled mutations execute exactly once; scheduled actions are at-most-once.

## Observability and control

- Read scheduling status from `ctx.db.system.get/query("_scheduled_functions", ...)`.
- Track job identifiers when follow-up status checks or cancellation are required.
- Design scheduled work to be idempotent when possible.

## Cron jobs

- Define recurring schedules in `convex/crons.ts` with `cronJobs()` and default export.
- Supported APIs include `interval`, `cron`, `hourly`, `daily`, `weekly`, and `monthly`.
- Prefer internal function references for cron targets.
- Use unique cron identifiers and keep schedules explicit (UTC semantics for cron expressions).
- At most one run per cron job executes at a time; overlapping runs may be skipped.

## Minimal example

```ts
// convex/messages.ts
import { mutation, internalMutation } from "./_generated/server";
import { internal } from "./_generated/api";
import { v } from "convex/values";

export const sendExpiring = mutation({
  args: { body: v.string() },
  returns: v.id("_scheduled_functions"),
  handler: async (ctx, args) => {
    const id = await ctx.db.insert("messages", { body: args.body });
    return await ctx.scheduler.runAfter(5_000, internal.messages.destroy, { id });
  },
});

export const destroy = internalMutation({
  args: { id: v.id("messages") },
  returns: v.null(),
  handler: async (ctx, args) => {
    await ctx.db.delete(args.id);
    return null;
  },
});
```
