# React GSAP Best Practices (Agent Rules)

This is the fast-path playbook. Use it to make decisions quickly, then consult section files for exact patterns and examples.

## Non-negotiables

- Use `useGSAP()` from `@gsap/react` for component-scoped animation lifecycle by default.
- Pass a `scope` ref so selector text remains local to the component.
- Revert GSAP context on teardown or update synchronization.
- Wrap delayed/event-driven GSAP work in `contextSafe()`.
- Keep effect setup/cleanup idempotent to survive React Strict Mode extra dev cycles.
- Keep GSAP code in client components only when using React server/client split frameworks.

## Core defaults

- Register `useGSAP` and animation plugins once, outside render paths.
- Store controllable timelines in refs instead of component state.
- Use dependency-driven re-runs with `revertOnUpdate: true` when animation inputs change.
- Co-locate ScrollTrigger creation with the component that owns the DOM.
- Respect reduced-motion and provide a non-animated fallback path.

## Full references

- `rules/react-gsap-setup.md`
- `rules/react-gsap-lifecycle.md`
- `rules/react-gsap-scrolltrigger.md`
- `rules/react-gsap-ssr-strictmode.md`
