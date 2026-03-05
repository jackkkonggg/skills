# GSAP Best Practices (Agent Rules)

This is the fast-path playbook. Use it to make decisions quickly, then consult section files for exact patterns and examples.

## Non-negotiables

- Register required GSAP plugins before creating animations that depend on them.
- Keep animation ownership local to the feature/component that creates it.
- Revert or kill animations/triggers on teardown to avoid leaks and stale listeners.
- Prefer transform and opacity animation over layout-triggering properties.
- Use `gsap.matchMedia()` for breakpoint-specific animation logic.
- Respect reduced-motion preferences for non-essential animation.

## Core defaults

- Build multi-step motion with timelines instead of chains of unrelated tweens.
- Use labels and named timeline segments for maintainable sequencing.
- Scope selector-based animation carefully; avoid broad global selectors.
- Keep scroll logic declarative through ScrollTrigger options rather than manual scroll handlers.
- Use scrub/pin/snap intentionally and test behavior on mobile and low-end devices.

## Full references

- `rules/gsap-core.md`
- `rules/gsap-timelines.md`
- `rules/gsap-scrolltrigger.md`
- `rules/gsap-performance.md`
