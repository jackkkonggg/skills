# GSAP Rules (ScrollTrigger)

## Canonical docs

- https://gsap.com/docs/v3/Plugins/ScrollTrigger/
- https://gsap.com/docs/v3/Plugins/ScrollTrigger/static.refresh()
- https://gsap.com/docs/v3/Plugins/ScrollTrigger/static.saveStyles()
- https://gsap.com/docs/v3/Plugins/ScrollTrigger/static.clearScrollMemory()
- https://gsap.com/docs/v3/GSAP/gsap.matchMedia()

## Setup

- Register `ScrollTrigger` before creating any scroll-driven animation.
- Keep each trigger close to the section/component it controls.
- Set explicit `start`/`end` values; avoid relying on implicit defaults for complex pages.

## Responsive behavior

- Use `gsap.matchMedia()` for breakpoint-specific trigger creation.
- Rebuild or refresh triggers after major layout changes (dynamic content, image load shifts, accordion expansion).
- Keep desktop pinning logic separate from mobile logic when interaction patterns differ.
- Use `ScrollTrigger.saveStyles(...)` when responsive reverts must restore pre-animation inline styles.

## Stability

- Clean up triggers on teardown to prevent duplicated listeners and ghost pin spacing.
- Use `scrub` and `snap` intentionally; both can increase computational cost when overused.
- Prefer declarative ScrollTrigger callbacks over custom window scroll listeners.
- Use `invalidateOnRefresh: true` when tween start values depend on layout that can change across refreshes.
- In SPA route flows with custom restoration behavior, use `ScrollTrigger.clearScrollMemory()` if stale position restoration appears.

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
