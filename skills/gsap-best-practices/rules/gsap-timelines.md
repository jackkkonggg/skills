# GSAP Rules (Timelines)

## Canonical docs

- https://gsap.com/docs/v3/GSAP/gsap.timeline()
- https://gsap.com/docs/v3/GSAP/Timeline/

## Composition

- Prefer timelines for sequences that share tempo, labels, or playback controls.
- Add labels for semantic checkpoints (`"intro"`, `"middle"`, `"outro"`) instead of relying only on numeric offsets.
- Keep timeline creation pure: build sequence first, then connect UI controls or event handlers.

## Control and reuse

- Expose timeline controls through a narrow API (`play`, `pause`, `seek`) instead of mutating internals broadly.
- Use timeline defaults for repeated ease/duration to reduce drift between steps.
- Avoid creating a new timeline on every state change when a parameterized update would work.

## Debuggability

- Use labels and `tl.seek("label")` during debugging to isolate sequence problems quickly.
- Keep nested timelines small and purpose-specific to avoid brittle orchestration.

## Minimal example

```ts
const tl = gsap.timeline({ defaults: { duration: 0.4, ease: "power2.out" } });

tl.addLabel("enter")
  .from(".title", { y: 24, autoAlpha: 0 })
  .from(".item", { y: 12, autoAlpha: 0, stagger: 0.05 }, "<0.1")
  .addLabel("ready");
```
