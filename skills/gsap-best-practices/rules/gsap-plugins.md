# GSAP Rules (Plugins)

## Canonical docs

- https://gsap.com/docs/v3/Plugins/
- https://gsap.com/docs/v3/Plugins/Flip/
- https://gsap.com/docs/v3/Plugins/SplitText/
- https://gsap.com/docs/v3/Plugins/DrawSVGPlugin/
- https://gsap.com/docs/v3/Plugins/MorphSVGPlugin/
- https://gsap.com/docs/v3/Plugins/ScrollToPlugin/
- https://gsap.com/docs/v3/Plugins/ScrollSmoother/

## Registration

- Register every plugin with `gsap.registerPlugin()` before first use.
- Register once at app startup or module initialization, not inside render loops or components that re-mount.
- `useGSAP` from `@gsap/react` is itself a plugin — register it before calling the hook.

## ScrollToPlugin

Animates scroll position of `window` or a scrollable element. Use for "scroll to" without ScrollTrigger.

```ts
gsap.registerPlugin(ScrollToPlugin);
gsap.to(window, { duration: 1, scrollTo: { y: "#section", offsetY: 50 } });
```

- `scrollTo.y` / `scrollTo.x` — target position (number), element/selector, or `"max"`.
- `offsetX` / `offsetY` — pixel offset from the target.

## ScrollSmoother

Smooth-scroll wrapper over native scroll. Requires ScrollTrigger and a specific DOM structure (`#smooth-wrapper` > `#smooth-content`). Register after ScrollTrigger. See docs for setup.

## Flip

Animate between layout states using the FLIP technique (First, Last, Invert, Play).

```ts
gsap.registerPlugin(Flip);
const state = Flip.getState(".item");
// apply DOM/class changes
Flip.from(state, { duration: 0.5, ease: "power2.inOut" });
```

- Always call `Flip.getState()` **before** the DOM change and `Flip.from()` **after**.
- Use `absolute: true` when elements change position in flow.
- Use `scale: true` (default) to scale elements to fit rather than stretching.

## Draggable

Makes elements draggable with mouse/touch. Requires explicit `.kill()` on teardown — not collected by `gsap.context()`.

```ts
gsap.registerPlugin(Draggable, InertiaPlugin);
Draggable.create(".box", { type: "x,y", bounds: "#container", inertia: true });
```

- Always define `type` (`"x"`, `"y"`, `"x,y"`, `"rotation"`, `"scroll"`) and `bounds`.
- Use `InertiaPlugin` for momentum after release (`inertia: true`).
- Kill instances on teardown: `draggableInstance.kill()`.

## Observer

Normalizes pointer, wheel, and touch input. Requires explicit `.kill()` on teardown — not collected by `gsap.context()`.

```ts
gsap.registerPlugin(Observer);
Observer.create({
  target: "#area",
  onUp: () => {},
  onDown: () => {},
  tolerance: 10,
});
```

- Use instead of separate native event listeners when GSAP timing integration is needed.
- Kill instances on teardown: `observerInstance.kill()`.

## SplitText

Splits text into characters, words, and/or lines for per-unit animation. Revert with `.revert()` or `gsap.context()`.

```ts
gsap.registerPlugin(SplitText);
const split = SplitText.create(".heading", { type: "words, chars" });
gsap.from(split.chars, { opacity: 0, y: 20, stagger: 0.03, duration: 0.4 });
```

- Split only what you animate (e.g. `"words, chars"` if not using lines) for performance.
- Use `autoSplit: true` with `onSplit()` callback so animations re-target after font load or resize re-split.
- Return the tween/timeline from `onSplit()` so SplitText can clean up and sync progress on re-split.
- `aria: "auto"` (default) adds `aria-label` on the split element and `aria-hidden` on children for screen readers.
- Use `mask: "lines"` (or `"words"` / `"chars"`) for clip/reveal effects — access wrappers via `.masks`.
- Avoid `text-wrap: balance`; it interferes with line splitting.
- SplitText does not support SVG `<text>`.

## ScrambleText

Animates text with a scramble/glitch reveal effect.

```ts
gsap.registerPlugin(ScrambleTextPlugin);
gsap.to(".text", { duration: 1, scrambleText: { text: "New message", chars: "01" } });
```

## DrawSVG (DrawSVGPlugin)

Reveals or hides SVG strokes by animating `stroke-dashoffset`/`stroke-dasharray`.

```ts
gsap.registerPlugin(DrawSVGPlugin);
gsap.from("#path", { duration: 1, drawSVG: 0 });
```

- The element **must** have a visible `stroke` and `stroke-width`.
- `drawSVG` value describes the visible segment: `"0% 100%"` = full, `"20% 80%"` = partial.
- Only affects stroke, not fill. Prefer single-segment `<path>` elements.

## MorphSVG (MorphSVGPlugin)

Morphs one SVG shape into another by animating path data. Start and end shapes do not need the same number of points.

```ts
gsap.registerPlugin(MorphSVGPlugin);
MorphSVGPlugin.convertToPath("circle, rect, ellipse, line");
gsap.to("#diamond", { duration: 1, morphSVG: "#lightning" });
```

- Convert non-path primitives with `MorphSVGPlugin.convertToPath()` first.
- Use `shapeIndex` to fix twisted or inverted morphs — try `shapeIndex: "log"` to find a good value.
- Use `type: "rotational"` when `"linear"` (default) produces mid-morph kinks.
- Use `smooth` (v3.14+) when the default morph looks jagged.
- Use `precompile` for very complex morphs to skip expensive startup calculations.

## MotionPath (MotionPathPlugin)

Animates an element along an SVG path.

```ts
gsap.registerPlugin(MotionPathPlugin);
gsap.to(".dot", { duration: 2, motionPath: { path: "#path", align: "#path", autoRotate: true } });
```

## CustomEase

Custom easing curves via cubic-bezier values or SVG path data.

```ts
gsap.registerPlugin(CustomEase);
const ease = CustomEase.create("hop", "M0,0 C0,0 0.056,0.442 0.175,0.442 ...");
gsap.to(".el", { x: 100, ease, duration: 1 });
```

- Simple cubic-bezier: `CustomEase.create("name", ".17,.67,.83,.67")`.
- Complex curves: use normalized SVG path data string.

## EasePack, CustomWiggle, CustomBounce

- `EasePack` adds named eases (SlowMo, RoughEase, ExpoScaleEase).
- `CustomWiggle` for wiggle/shake oscillation easing.
- `CustomBounce` for configurable bounce easing.
- Register each before use.

## Physics2D / PhysicsProps

- `Physics2DPlugin` — 2D physics with velocity, angle, gravity for projectile-style motion.
- `PhysicsPropsPlugin` — physics-driven property animation with velocity and acceleration.

## GSDevTools

Scrubbing/debugging UI for timelines. **Development only — do not ship to production.**

```ts
gsap.registerPlugin(GSDevTools);
GSDevTools.create({ animation: tl });
```

## PixiPlugin

Integrates GSAP with PixiJS for animating Pixi display objects. Register when using GSAP to animate Pixi sprites.

## Do not

- Do not use any plugin without registering it first via `gsap.registerPlugin()`.
- Do not ship `GSDevTools` or `MotionPathHelper` to production.
- Do not forget to `.kill()` Draggable and Observer instances on teardown — they are not auto-collected.
- Do not forget to revert SplitText instances (`.revert()` or `gsap.context()`) when elements are removed.
