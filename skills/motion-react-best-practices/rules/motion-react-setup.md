# Motion React Rules (Setup and Imports)

## Canonical docs

- https://motion.dev/docs/react-installation
- https://motion.dev/docs/react-upgrade-guide
- https://motion.dev/docs/react-motion-component
- https://motion.dev/docs/react-lazy-motion
- https://react.dev/reference/react/useEffect

## Baseline setup

- Install `motion` and treat `framer-motion` imports as migration debt for modern codebases.
- Import React Motion APIs from `motion/react`.
- For React Server Components surfaces, import visual components via `motion/react-client` and keep animation hooks in client components.
- Keep animation creation in lifecycle boundaries (hooks/effects), never in render.
- Prefer colocated feature-level animation ownership over global animation registries.

## Bundle and feature loading

- Use `LazyMotion` when animation features are not required on initial render.
- Use `domAnimation` for common UI transitions; use `domMax` only when advanced gesture/drag features are needed globally.
- Import lightweight `m` components (`motion/react-m`) under `LazyMotion` when bundle budgets are tight.

## Integration policy

- Avoid mixing CSS transitions and Motion on the same properties at the same time.
- Keep refs stable for animated nodes that need imperative control.
- Centralize reusable defaults with `MotionConfig` when a feature should share timing/ease policy.

## Minimal example

```tsx
import { LazyMotion, domAnimation, motion } from "motion/react";

export function Card({ open }: { open: boolean }) {
  return (
    <LazyMotion features={domAnimation}>
      <motion.section
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.24 }}
      >
        {open ? "Open" : "Closed"}
      </motion.section>
    </LazyMotion>
  );
}
```
