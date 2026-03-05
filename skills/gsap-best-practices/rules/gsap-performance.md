# GSAP Rules (Performance and Accessibility)

## Canonical docs

- https://gsap.com/docs/v3/GSAP/
- https://gsap.com/docs/v3/GSAP/gsap.matchMedia()
- https://gsap.com/docs/v3/GSAP/gsap.quickTo()
- https://gsap.com/docs/v3/GSAP/gsap.quickSetter()
- https://gsap.com/docs/v3/GSAP/gsap.killTweensOf()
- https://gsap.com/resources/react-basics/

## Performance defaults

- Prefer `x`, `y`, `scale`, `rotation`, and `autoAlpha` over `top`, `left`, `width`, and `height` when possible.
- Keep concurrent animations bounded; stagger lists instead of animating every item at once.
- Use `will-change` sparingly and remove it when animation ends.
- Avoid expensive per-frame work inside `onUpdate` callbacks.
- For very high-frequency input loops (pointermove/ticker), prefer `quickSetter()` or `quickTo()` over creating new tweens each event.
- Kill superseded tweens (`killTweensOf`) in interactive flows where rapidly repeated input can stack motion.

## Rendering stability

- Avoid layout thrashing: do not interleave reads and writes in high-frequency callbacks.
- Avoid large, continuously scrubbing timelines for off-screen content.
- Use GPU-friendly transforms for high-frequency interactions.

## Accessibility

- Respect `prefers-reduced-motion` and provide a reduced/instant experience for non-essential motion.
- Keep essential state changes perceivable without relying only on motion.
- Avoid motion patterns that can cause disorientation (rapid large-axis movement, constant parallax).

## Minimal example

```ts
const mm = gsap.matchMedia();

mm.add("(prefers-reduced-motion: reduce)", () => {
  gsap.set(".hero", { clearProps: "all" });
});

mm.add("(prefers-reduced-motion: no-preference)", () => {
  gsap.from(".hero", { y: 24, autoAlpha: 0, duration: 0.5, ease: "power2.out" });
});
```
