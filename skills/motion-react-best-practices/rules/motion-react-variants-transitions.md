# Motion React Rules (Variants and Transitions)

## Canonical docs

- https://motion.dev/docs/react-animation
- https://motion.dev/docs/react-transitions
- https://motion.dev/docs/react-motion-component
- https://motion.dev/docs/react-motion-config

## Variant architecture

- Prefer named `variants` for coordinated multi-element state changes (`open`, `closed`, `enter`, `exit`).
- Keep variant state names semantically stable across related components.
- Use `initial={false}` when first-render animation should be skipped for stateful surfaces.
- Keep variant objects close to component logic unless intentionally reused by multiple features.

## Transition policy

- Set explicit `duration`, `ease`, or spring configuration for predictable behavior.
- Use `staggerChildren`/`delayChildren` through parent variants for deterministic orchestration.
- Avoid stacking multiple concurrent springs on one property unless physically intentional.
- Use `MotionConfig` for shared feature defaults rather than repeating transition config on each node.

## State and interaction safety

- Keep hover/tap/focus animation targets narrow to avoid layout jitter.
- Use transform and opacity for common transitions; avoid unnecessary layout-affecting properties.
- Keep interaction feedback fast; avoid long easing curves for control affordances.

## Minimal example

```tsx
import { motion } from "motion/react";

const menu = {
  open: { opacity: 1, transition: { staggerChildren: 0.05 } },
  closed: { opacity: 0 },
};

const item = {
  open: { y: 0, opacity: 1 },
  closed: { y: 8, opacity: 0 },
};

export function Menu({ open }: { open: boolean }) {
  return (
    <motion.ul initial={false} animate={open ? "open" : "closed"} variants={menu}>
      <motion.li variants={item}>One</motion.li>
      <motion.li variants={item}>Two</motion.li>
    </motion.ul>
  );
}
```
