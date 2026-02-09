# Convex Rules (Components)

## Canonical docs

- https://docs.convex.dev/components
- https://docs.convex.dev/components/understanding
- https://docs.convex.dev/components/using
- https://docs.convex.dev/components/authoring

## Isolation model

- Treat components as isolated backends with their own tables and execution environment.
- Do not assume components can read app tables or call app functions unless explicitly wired.
- Pass only minimal required capabilities across component boundaries.
- Remember component mutations run as sub-transactions that can be caught/handled by callers.

## Adoption guidance

- Prefer components for reusable backend features that should remain modular and sandboxed.
- Keep component configuration explicit and versioned.
- Review component docs and exposed interfaces before integrating into production workflows.
- Register and configure component instances in `convex/convex.config.ts`.

## Authoring guidance

- Keep component APIs narrow and composable.
- Avoid leaking app-specific assumptions into reusable component contracts.
- For local components, keep generated APIs up to date with `convex dev`.

## Minimal example

```ts
// convex/convex.config.ts
import { defineApp } from "convex/server";
import agent from "@convex-dev/agent/convex.config.js";

const app = defineApp();
app.use(agent);
export default app;
```
