# GSAP Rules (Timelines)

## Canonical docs

- https://gsap.com/docs/v3/GSAP/gsap.timeline()
- https://gsap.com/docs/v3/GSAP/Timeline/

## Composition

- Prefer timelines for sequences that share tempo, labels, or playback controls.
- Add labels for semantic checkpoints (`"intro"`, `"middle"`, `"outro"`) instead of relying only on numeric offsets.
- Keep timeline creation pure: build sequence first, then connect UI controls or event handlers.
- Pass `defaults` into the timeline constructor so child tweens inherit duration, ease, etc.

## Position parameter

The third argument to `.to()`, `.from()`, `.fromTo()` controls placement in the timeline:

| Syntax | Meaning |
|---|---|
| `1` | absolute — start at 1 second |
| `"+=0.5"` | 0.5s after end of previous |
| `"-=0.2"` | 0.2s before end of previous (overlap) |
| `"labelName"` | at that label |
| `"labelName+=0.3"` | 0.3s after the label |
| `"<"` | start when the most recently added animation **starts** |
| `">"` | start when the most recently added animation **ends** (default) |
| `"<0.2"` | 0.2s after the most recently added animation starts |

```ts
tl.to(".a", { x: 100 }, 0);         // at time 0
tl.to(".b", { y: 50 }, "<");        // same start as previous
tl.to(".c", { opacity: 0 }, "<0.2"); // 0.2s after previous start
```

## Timeline constructor options

- `defaults` — vars merged into every child tween.
- `paused: true` — create paused; call `.play()` to start.
- `repeat`, `yoyo` — apply to the whole timeline.
- `onComplete`, `onStart`, `onUpdate` — timeline-level callbacks.
- Note: `duration` on the constructor does **not** set child tween duration — timeline duration is determined by its children.

## Labels

```ts
tl.addLabel("intro", 0);
tl.to(".a", { x: 100 }, "intro");
tl.addLabel("outro", "+=0.5");
tl.tweenFromTo("intro", "outro"); // animate playhead between labels
```

## Nesting

Timelines can contain other timelines via `.add()`:

```ts
const master = gsap.timeline();
const child = gsap.timeline();
child.to(".a", { x: 100 }).to(".b", { y: 50 });
master.add(child, 0);
```

Keep nested timelines small and purpose-specific.

## Playback control

- `tl.play()` / `tl.pause()` / `tl.reverse()` / `tl.restart()`
- `tl.time(2)` — seek to 2 seconds.
- `tl.progress(0.5)` — seek to 50%.
- `tl.kill()` — kill timeline and its children.

## Control and reuse

- Expose timeline controls through a narrow API (`play`, `pause`, `seek`) instead of mutating internals broadly.
- Use timeline defaults for repeated ease/duration to reduce drift between steps.
- Avoid creating a new timeline on every state change when a parameterized update would work.
- Store timelines in stable references (refs in React, module scope in vanilla) for deterministic control.

## Debuggability

- Use labels and `tl.seek("label")` during debugging to isolate sequence problems quickly.
- Keep nested timelines small and purpose-specific to avoid brittle orchestration.

## Do not

- Do not chain animations with `delay` when a timeline can sequence them — prefer `gsap.timeline()` and the position parameter.
- Do not put ScrollTrigger on child tweens inside a timeline — put it on the **timeline** or a top-level tween. Wrong: `tl.to(".a", { scrollTrigger: {...} })`. Correct: `gsap.timeline({ scrollTrigger: {...} }).to(...)`.
- Do not nest ScrollTriggered animations inside a parent timeline — ScrollTriggers must only exist on top-level animations.
- Do not confuse timeline `duration` constructor option with child tween duration — timeline duration is derived from its children.

## Minimal example

```ts
const tl = gsap.timeline({ defaults: { duration: 0.4, ease: "power2.out" } });

tl.addLabel("enter")
  .from(".title", { y: 24, autoAlpha: 0 })
  .from(".item", { y: 12, autoAlpha: 0, stagger: 0.05 }, "<0.1")
  .addLabel("ready");
```
