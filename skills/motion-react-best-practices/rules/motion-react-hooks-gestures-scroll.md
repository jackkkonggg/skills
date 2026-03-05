# Motion React Rules (Hooks, Gestures, and Scroll)

## Canonical docs

- https://motion.dev/docs/react-gestures
- https://motion.dev/docs/react-use-animate
- https://motion.dev/docs/react-use-in-view
- https://motion.dev/docs/react-use-scroll
- https://motion.dev/docs/react-use-transform
- https://motion.dev/docs/react-use-spring
- https://motion.dev/docs/react-use-motion-value-event

## Hook usage

- Use Motion hooks as the primary source for animation signals instead of manual event plumbing.
- Use `useInView` to trigger viewport-bound reveals rather than custom intersection boilerplate.
- Use `useScroll` + motion values to map scroll progress to transforms and opacity.
- Use `useTransform` and `useSpring` to derive smoother values from primary motion signals.
- Use `useAnimate` when imperative sequence control is needed within a local scope.

## Gesture and drag policy

- Keep gesture targets explicit (`whileHover`, `whileTap`, `drag`) and constrained to owned components.
- Define `dragConstraints` and `dragElastic` intentionally for predictable UX.
- Avoid gesture interactions that conflict with native scrolling on touch surfaces.
- Keep pointer-driven effects lightweight and avoid creating new animations for every pointer event.

## Motion value coordination

- Subscribe with `useMotionValueEvent` when reacting to value changes for side effects.
- Avoid unnecessary React state updates from high-frequency motion value changes.
- Keep derived value chains shallow and readable to simplify debugging.

## Minimal example

```tsx
import { motion, useScroll, useSpring, useTransform } from "motion/react";

export function ReadingProgress() {
  const { scrollYProgress } = useScroll();
  const width = useSpring(scrollYProgress, { stiffness: 220, damping: 30 });
  const opacity = useTransform(scrollYProgress, [0, 0.03], [0, 1]);

  return <motion.div style={{ scaleX: width, opacity, transformOrigin: "0% 50%" }} />;
}
```
