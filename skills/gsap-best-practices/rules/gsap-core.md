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

## Tween methods

- `gsap.to(targets, vars)` — animate from current state to `vars`. Most common.
- `gsap.from(targets, vars)` — animate from `vars` to current state (entrances).
- `gsap.fromTo(targets, fromVars, toVars)` — explicit start and end; no reading of current values.
- `gsap.set(targets, vars)` — apply immediately (duration 0).

## Tween defaults

- Use `fromTo` when starting values must be deterministic across repeated runs.
- Use `overwrite: "auto"` for interactions where multiple tweens may target the same properties.
- Keep durations and eases explicit for predictable motion.
- Consider `gsap.defaults(...)` for shared tween defaults in a bounded scope to reduce drift.

## Transform aliases

Prefer GSAP's transform aliases over raw `transform` strings — they apply in a consistent order, are more performant, and work reliably across browsers.

| GSAP property | Equivalent |
|---|---|
| `x`, `y`, `z` | translateX/Y/Z (default: px) |
| `xPercent`, `yPercent` | translateX/Y in %; work on SVG |
| `scale`, `scaleX`, `scaleY` | scale; `scale` sets both X and Y |
| `rotation` | rotate (default: deg; or `"1.25rad"`) |
| `rotationX`, `rotationY` | 3D rotate |
| `skewX`, `skewY` | skew |
| `transformOrigin` | e.g. `"left top"`, `"50% 50%"` |

- **autoAlpha** — Prefer over `opacity` for fade in/out. At `0` GSAP also sets `visibility: hidden` (better rendering, no pointer events); at non-zero sets `visibility: inherit`.
- **Relative values** — `x: "+=20"`, `rotation: "-=30"`, `scale: "*=2"`.
- **Function-based values** — `x: (i, target, targets) => i * 50` — called once per target on first render.
- **clearProps** — `clearProps: "all"` removes inline styles on tween complete so CSS classes take over. Clearing any transform property clears the entire transform.
- **svgOrigin** _(SVG only)_ — like `transformOrigin` but in global SVG coordinates. Do not use both on the same element.
- **Directional rotation** — append `_short`, `_cw`, or `_ccw` to rotation string values: `rotation: "-170_short"`.

## immediateRender

- `from()` and `fromTo()` default to `immediateRender: true` — start state is applied at creation time.
- When **stacking multiple `from()` or `fromTo()` tweens** on the same property of the same element, set `immediateRender: false` on the later ones so the first tween's end state is not overwritten before it runs.

## Easing

Use string eases unless a custom curve is needed. Built-in eases (base = `.out`):

```
"none" (linear)
"power1" / "power2" / "power3" / "power4"   — each with .in / .out / .inOut
"back" / "bounce" / "circ" / "elastic" / "expo" / "sine"  — each with .in / .out / .inOut
```

Configurable: `"back.out(1.7)"`, `"elastic.out(1, 0.3)"`. For custom curves use `CustomEase` plugin (see `rules/gsap-plugins.md`).

## gsap.matchMedia()

Runs setup code only when a media query matches; auto-reverts when it stops matching. Use for responsive breakpoints and `prefers-reduced-motion`.

- **Conditions syntax** — pass an object of named queries; handler receives `context.conditions`:

```ts
mm.add({
  isDesktop: "(min-width: 800px)",
  reduceMotion: "(prefers-reduced-motion: reduce)",
}, (context) => {
  const { isDesktop, reduceMotion } = context.conditions;
  gsap.to(".box", { rotation: isDesktop ? 360 : 180, duration: reduceMotion ? 0 : 2 });
});
```

- Do not nest `gsap.context()` inside matchMedia — it creates a context internally.
- Use `mm.revert()` on teardown. Use `gsap.matchMediaRefresh()` to re-run all matching handlers.

## Do not

- Do not animate layout-heavy properties (`width`, `height`, `top`, `left`) when transforms can achieve the same effect.
- Do not use both `svgOrigin` and `transformOrigin` on the same SVG element.
- Do not rely on default `immediateRender: true` when stacking multiple `from()`/`fromTo()` tweens on the same property — set `immediateRender: false` on later ones.
- Do not use invalid or non-existent ease names; stick to documented built-in eases.
- Do not mix CSS transitions with GSAP on the same property at the same time.

## Minimal example

```ts
import gsap from "gsap";

const tl = gsap.timeline({ defaults: { duration: 0.5, ease: "power2.out" } });
tl.fromTo(".card", { y: 24, autoAlpha: 0 }, { y: 0, autoAlpha: 1, stagger: 0.06 });
```
