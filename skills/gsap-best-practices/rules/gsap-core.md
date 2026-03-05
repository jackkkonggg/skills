# GSAP Rules (Core)

## Canonical docs

- https://gsap.com/docs/v3/GSAP/
- https://gsap.com/docs/v3/GSAP/gsap.context()
- https://gsap.com/docs/v3/GSAP/gsap.defaults()
- https://gsap.com/docs/v3/GSAP/gsap.matchMedia()
- https://gsap.com/docs/v3/GSAP/gsap.registerPlugin()

## Setup and ownership

- As of March 6, 2026, GSAP docs state that all plugins, including the former bonus plugins, are available through the public package. Use normal npm/package imports and avoid legacy private-registry guidance like `npm.greensock.com`.
- If installation guidance is part of the task, prefer GSAP `3.13+` so public plugin availability matches current docs.
- Register plugins once during app startup or module initialization, not inside tight render/update loops.
- Create animations as close as possible to the feature that owns the DOM nodes.
- Store long-lived timelines/tweens in stable references so control methods (`play`, `pause`, `reverse`) are deterministic.
- Avoid mixing CSS transitions with GSAP on the same property at the same time.

## Context and cleanup

- In framework code, prefer `gsap.context()` to collect all GSAP work created during setup.
- Always call `ctx.revert()` on teardown so animations, inline style changes, and ScrollTriggers are cleaned up together.
- Use `gsap.matchMedia()` per setup boundary and call `mm.revert()` during teardown.

## Selector and target policy

- Prefer explicit element references over global selector strings.
- If selector text is necessary, scope selection to a local container instead of `document`.
- Avoid animating elements that can disappear during the animation without teardown logic.

## Tween defaults

- Use `fromTo` when starting values must be deterministic across repeated runs.
- Use `overwrite: "auto"` for interactions where multiple tweens may target the same properties.
- Keep durations and eases explicit for predictable motion.
- Consider `gsap.defaults(...)` for shared tween defaults in a bounded scope to reduce drift.

## Minimal example

```ts
import gsap from "gsap";

const tl = gsap.timeline({ defaults: { duration: 0.5, ease: "power2.out" } });
tl.fromTo(".card", { y: 24, autoAlpha: 0 }, { y: 0, autoAlpha: 1, stagger: 0.06 });
```
