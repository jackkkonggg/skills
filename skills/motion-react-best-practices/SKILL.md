---
name: motion-react-best-practices
description: Use when writing, reviewing, or refactoring React components that use Motion (`motion/react`) to implement animations, gestures, scroll-linked effects, layout transitions, and exit/enter choreography with production-safe lifecycle, accessibility, and performance patterns.
---

# Motion React Best Practices

Apply these rules when working on React codebases that use Motion.

## Rule loading order

1. Read `rules/motion-react-setup.md`.
2. Read `rules/motion-react-variants-transitions.md`.
3. Read `rules/motion-react-presence-layout.md`.
4. Read `rules/motion-react-hooks-gestures-scroll.md`.
5. Read `rules/motion-react-performance-accessibility.md`.
6. Use `AGENTS.md` as a compact summary plus pointer.

## Enforcement policy

- Use recommendation-first language for style and performance guidance.
- Use strict language (`must` / `must not`) only for lifecycle correctness, accessibility, and regression-risk behavior.
- Prefer official Motion and React docs when resolving conflicts; update these rules when docs change.
