# Convex Rules (Realtime)

## Canonical docs

- https://docs.convex.dev/realtime
- https://docs.convex.dev/functions/query-functions
- https://docs.convex.dev/client/react

## Reactive query defaults

- Build read paths as query functions; Convex subscriptions, caching, and realtime updates come from query usage.
- Prefer query-driven UI state over manual polling or ad-hoc cache invalidation.
- Keep query return shapes stable to avoid noisy client rerenders.

## Consistency and determinism

- Keep query/mutation logic deterministic and side-effect free where required by runtime constraints.
- Do not introduce nondeterministic behavior in queries/mutations that can break retry/replay assumptions.
- Prefer storing canonical state in Convex and deriving view state from queries.

## Practical guidance

- Use pagination for long feeds and infinite-scroll UIs instead of loading everything reactively.
- Prefer indexes/search indexes so reactive queries stay within scan limits as data grows.
- Remember realtime query caching reduces repeated database bandwidth costs.
- Assume all clients should see consistent snapshots from the same committed state.

## Minimal example

```tsx
import { useQuery } from "convex/react";
import { api } from "../convex/_generated/api";

export function PresenceBadge({ roomId }: { roomId: string }) {
  const room = useQuery(api.rooms.getById, { roomId });
  if (!room) return null;
  return <span>{room.onlineCount} online</span>;
}
```
