# Motion React Best Practices (Agent Rules)

Use this as the fast-path playbook, then open the rule files for exact guidance and examples.

## Non-negotiables

- Install `motion` and import React APIs from `motion/react` (or `motion/react-client` for React Server Component surfaces).
- Keep animation setup inside React lifecycle boundaries, not during render.
- Use `AnimatePresence` for exit animations and always provide stable keys for exiting children.
- Use `layout`/`layoutId`/`LayoutGroup` deliberately to avoid broken shared transitions.
- Respect reduced-motion preferences and keep state changes perceivable without motion.

## Core defaults

- Prefer named `variants` for multi-element choreography and shared state transitions.
- Use `MotionConfig` and transition defaults to keep motion consistent across a feature.
- Prefer `LazyMotion` plus `domAnimation`/`domMax` when bundle size matters.
- Prefer motion values (`useScroll`, `useTransform`, `useSpring`) over manual high-frequency DOM writes.
- Keep gesture and drag constraints explicit; avoid physics defaults that feel unstable for UI controls.

## Full references

- `rules/motion-react-setup.md`
- `rules/motion-react-variants-transitions.md`
- `rules/motion-react-presence-layout.md`
- `rules/motion-react-hooks-gestures-scroll.md`
- `rules/motion-react-performance-accessibility.md`
