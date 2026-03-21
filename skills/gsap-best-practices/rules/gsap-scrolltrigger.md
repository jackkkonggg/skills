# GSAP Rules (ScrollTrigger)

## Canonical docs

- https://gsap.com/docs/v3/Plugins/ScrollTrigger/
- https://gsap.com/docs/v3/Plugins/ScrollTrigger/static.refresh()
- https://gsap.com/docs/v3/Plugins/ScrollTrigger/static.batch()
- https://gsap.com/docs/v3/Plugins/ScrollTrigger/static.scrollerProxy()
- https://gsap.com/docs/v3/Plugins/ScrollTrigger/static.saveStyles()
- https://gsap.com/docs/v3/Plugins/ScrollTrigger/static.clearScrollMemory()
- https://gsap.com/docs/v3/GSAP/gsap.matchMedia()

## Setup

- Register `ScrollTrigger` before creating any scroll-driven animation.
- Keep each trigger close to the section/component it controls.
- Set explicit `start`/`end` values; avoid relying on implicit defaults for complex pages.

## Key config options

| Property | Description |
|---|---|
| `trigger` | Element whose position defines start. Required. |
| `start` / `end` | Format: `"triggerPos viewportPos"` (e.g. `"top center"`, `"bottom 80%"`). Can be number, function, or use `clamp()`. |
| `endTrigger` | Element for `end` when different from `trigger`. |
| `scrub` | Link progress to scroll. `true` = direct; number = seconds to catch up. |
| `toggleActions` | Four actions: onEnter, onLeave, onEnterBack, onLeaveBack. Each: `"play"` / `"pause"` / `"resume"` / `"reset"` / `"restart"` / `"complete"` / `"reverse"` / `"none"`. |
| `pin` | Pin an element while active. `true` = pin trigger. Animate children, not the pinned element itself. |
| `pinSpacing` | Default `true` (adds spacer). `false` or `"margin"` when layout is handled separately. |
| `snap` | Snap to progress values. Number (increments), array, `"labels"`, or config object with `snapTo`, `duration`, `delay`, `ease`. |
| `horizontal` | `true` for horizontal scrolling. |
| `scroller` | Scroll container (default: viewport). |
| `markers` | `true` for dev markers. **Remove in production.** |
| `once` | Kill trigger after end is reached once. |
| `refreshPriority` | Lower = refreshed first. Use when creation order doesn't match page order. |
| `toggleClass` | Add/remove class when active. String or `{ targets, className }`. |
| `containerAnimation` | For horizontal scroll: the tween/timeline moving content horizontally. |

**Standalone triggers** (no linked tween): use `ScrollTrigger.create()` with callbacks:

```ts
ScrollTrigger.create({
  trigger: "#id",
  start: "top top",
  end: "bottom 50%+=100px",
  onUpdate: (self) => console.log(self.progress.toFixed(3), self.direction),
});
```

## Scrub vs toggleActions

- Use `scrub` for scroll-linked progress (animation tied to scroll position).
- Use `toggleActions` for discrete play/reverse behavior.
- **Do not use both on the same trigger** — if both exist, `scrub` wins.

## Pinning

- `pin: true` pins the trigger element while the scroll range is active.
- `pinSpacing: true` (default) adds a spacer so layout doesn't collapse.
- Animate **children** of the pinned element, not the pinned element itself.

## Horizontal scroll (containerAnimation)

Pin a section, animate inner content's `x`/`xPercent` horizontally, tie to vertical scroll:

```ts
const scrollTween = gsap.to(".horizontal-content", {
  xPercent: -100 * (panels.length - 1),
  ease: "none", // REQUIRED
  scrollTrigger: {
    trigger: ".horizontal-wrapper",
    pin: true,
    scrub: true,
    end: "+=3000",
  },
});

// Triggers based on horizontal movement reference containerAnimation:
gsap.to(".nested", {
  y: 100,
  scrollTrigger: {
    containerAnimation: scrollTween,
    trigger: ".nested-wrapper",
    start: "left center",
    toggleActions: "play none none reset",
  },
});
```

- The horizontal tween **must** use `ease: "none"` — a very common mistake that breaks scroll-position mapping.
- Pinning and snapping are **not** available on `containerAnimation`-based ScrollTriggers.
- Animate a child, not the trigger element itself.

## ScrollTrigger.batch()

Batches callbacks for multiple elements that fire around the same time. Good alternative to IntersectionObserver.

```ts
ScrollTrigger.batch(".box", {
  onEnter: (elements) => gsap.to(elements, { opacity: 1, y: 0, stagger: 0.15 }),
  onLeave: (elements) => gsap.to(elements, { opacity: 0, y: 100 }),
  start: "top 80%",
});
```

- Batched callbacks receive `(targets, scrollTriggers)` — different from normal callbacks.
- Config supports `interval` (batch collection time) and `batchMax` (max elements per batch).
- Do not pass `trigger`, `animation`, `scrub`, `snap`, or `toggleActions` in batch config.

## ScrollTrigger.scrollerProxy()

Overrides how ScrollTrigger reads/writes scroll position for a custom scroller (e.g. third-party smooth-scroll library). Not needed for GSAP's ScrollSmoother.

- Provide `scrollTop` and/or `scrollLeft` as getter/setter functions.
- **Critical:** notify ScrollTrigger when the scroller updates: `smoothScroller.addListener(ScrollTrigger.update)`.

## Creation order and refreshPriority

- `ScrollTrigger.refresh()` runs in creation order (or by `refreshPriority`).
- Create ScrollTriggers top-to-bottom on the page, or set `refreshPriority` so they refresh in page order (first section = lower number).
- Wrong order can affect pin spacing calculations.

## Responsive behavior

- Use `gsap.matchMedia()` for breakpoint-specific trigger creation.
- Rebuild or refresh triggers after major layout changes (dynamic content, image load shifts, accordion expansion).
- Keep desktop pinning logic separate from mobile logic when interaction patterns differ.
- Use `ScrollTrigger.saveStyles(...)` when responsive reverts must restore pre-animation inline styles.

## Refresh and cleanup

- Call `ScrollTrigger.refresh()` after DOM/layout changes that affect trigger positions. Viewport resize is auto-handled (debounced 200ms), but dynamic content is not.
- Clean up triggers on teardown to prevent duplicated listeners and ghost pin spacing.
- Use `invalidateOnRefresh: true` when tween start values depend on layout that can change across refreshes.
- In SPA route flows, use `ScrollTrigger.clearScrollMemory()` if stale position restoration appears.

## Do not

- Do not put ScrollTrigger on child tweens inside a timeline — put it on the timeline or a top-level tween.
- Do not nest ScrollTriggered animations inside a parent timeline.
- Do not use `scrub` and `toggleActions` together on the same trigger.
- Do not use an ease other than `"none"` on the horizontal animation when using `containerAnimation`.
- Do not create ScrollTriggers in random order without setting `refreshPriority`.
- Do not leave `markers: true` in production.
- Do not forget `ScrollTrigger.refresh()` after layout changes; viewport resize is auto-handled but dynamic content is not.

## Minimal example

```ts
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";

gsap.registerPlugin(ScrollTrigger);

gsap.to(".panel", {
  yPercent: -30,
  ease: "none",
  scrollTrigger: {
    trigger: ".panel",
    start: "top bottom",
    end: "bottom top",
    scrub: true,
  },
});
```
