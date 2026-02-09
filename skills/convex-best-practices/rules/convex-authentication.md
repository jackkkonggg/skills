# Convex Rules (Authentication)

## Canonical docs

- https://docs.convex.dev/auth
- https://docs.convex.dev/auth/functions-auth
- https://docs.convex.dev/auth/database-auth
- https://docs.convex.dev/auth/advanced/custom-auth
- https://docs.convex.dev/auth/advanced/custom-jwt

## Boundary security

- Treat all public Convex functions as internet-exposed endpoints.
- Authenticate identity before performing protected reads/writes.
- Authorize each request at function boundaries based on user, tenant, role, or resource ownership.

## API design

- Prefer internal functions for sensitive operations that clients should never call directly.
- Keep public mutations focused on validating user intent and enforcing authorization invariants.
- Pass only necessary auth-derived fields into downstream internal functions.

## Service-to-service access

- For non-user service calls, protect public endpoints with explicit shared-secret or equivalent service auth checks.
- Keep service credentials in environment variables and fail closed when missing.
- Prefer standards-compatible JWT/OIDC providers for user auth flows.

## Reliability

- Log auth failures with minimal sensitive context.
- Return safe errors that do not leak privileged data.
- Keep authorization logic close to data mutations to prevent bypass paths.

## Minimal example

```ts
import { mutation } from "./_generated/server";
import { v } from "convex/values";

export const removeOwnProfilePhoto = mutation({
  args: { photoId: v.id("_storage") },
  returns: v.null(),
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) throw new Error("Unauthenticated");
    const user = await ctx.db
      .query("users")
      .withIndex("by_token", (q) => q.eq("tokenIdentifier", identity.tokenIdentifier))
      .unique();
    if (!user || user.photoId !== args.photoId) throw new Error("Forbidden");
    await ctx.db.patch("users", user._id, { photoId: undefined });
    return null;
  },
});
```
