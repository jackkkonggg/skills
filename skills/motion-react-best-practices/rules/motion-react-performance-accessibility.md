# Motion React Rules (Performance and Accessibility)

## Canonical docs

- https://motion.dev/docs/react-accessibility
- https://motion.dev/docs/react-use-reduced-motion
- https://motion.dev/docs/react-motion-config
- https://motion.dev/docs/react-lazy-motion
- https://react.dev/reference/react/StrictMode

## Accessibility policy

- Respect `prefers-reduced-motion` via `useReducedMotion` or `MotionConfig` reduced-motion settings.
- Replace high-travel transform animations with opacity or minimal-distance alternatives when reduced motion is requested.
- Keep essential information and state changes understandable without relying on motion.
- Avoid prolonged, autoplaying, or high-amplitude animations that can reduce usability.

## Performance defaults

- Prefer transform/opacity animations over layout-thrashing properties.
- Limit simultaneously animating elements; stagger when possible.
- Keep animation work local and tear down effects on unmount.
- Use `LazyMotion` where route-level or feature-level code splitting is needed.

## React integration safeguards

- Ensure animation setup/cleanup is resilient to React Strict Mode development re-runs.
- Keep effects idempotent so mount/unmount cycles do not duplicate in-flight animation behavior.
- Avoid writing high-frequency animation state into React component state.

## Minimal example

```tsx
import { motion, useReducedMotion } from "motion/react";

export function Sidebar({ open }: { open: boolean }) {
  const reduceMotion = useReducedMotion();

  return (
    <motion.aside
      animate={
        open
          ? reduceMotion
            ? { opacity: 1 }
            : { x: 0, opacity: 1 }
          : reduceMotion
            ? { opacity: 0 }
            : { x: "-100%", opacity: 0 }
      }
      transition={{ duration: 0.2 }}
    />
  );
}
```
