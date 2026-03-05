# Motion React Rules (AnimatePresence and Layout)

## Canonical docs

- https://motion.dev/docs/react-animate-presence
- https://motion.dev/docs/react-layout-animations
- https://motion.dev/docs/react-layout-group

## Exit/enter choreography

- Wrap conditionally rendered elements with `AnimatePresence` when exit animation is required.
- Provide stable keys for every child inside `AnimatePresence`; missing/unstable keys break exits.
- Keep `initial`/`animate`/`exit` definitions explicit for elements that appear and disappear repeatedly.
- Prefer presence-aware sequencing modes intentionally (`sync`, `wait`, `popLayout`) based on UX requirements.

## Layout animation policy

- Use `layout` for natural interpolation of layout changes from React re-renders.
- Use `layoutId` for shared-element transitions between mutually exclusive views.
- Use `LayoutGroup` when coordinating related layout animations across component boundaries.
- Avoid applying `layout` broadly to large trees when only a subset needs animated layout transitions.

## Stability safeguards

- Keep DOM structure predictable during transitions to avoid jank and snap-backs.
- Avoid abrupt unmounting outside `AnimatePresence` when visual continuity is required.
- Ensure parent containers allow transformed/animated children without clipping surprises unless intentional.

## Minimal example

```tsx
import { AnimatePresence, LayoutGroup, motion } from "motion/react";

export function FilterTabs({
  active,
  items,
}: {
  active: string;
  items: string[];
}) {
  return (
    <LayoutGroup>
      <motion.ul layout>
        <AnimatePresence mode="popLayout">
          {items.map((name) => (
            <motion.li layout key={name}>
              <button>{name}</button>
              {active === name ? <motion.div layoutId="underline" /> : null}
            </motion.li>
          ))}
        </AnimatePresence>
      </motion.ul>
    </LayoutGroup>
  );
}
```
