# React GSAP Rules (Lifecycle and Dependencies)

## Canonical docs

- https://github.com/greensock/react
- https://react.dev/reference/react/useEffect
- https://react.dev/reference/react/useLayoutEffect

## Lifecycle policy

- Treat `useGSAP` as the default lifecycle boundary for GSAP in React components.
- Keep setup and cleanup symmetrical so re-mount/re-sync leaves no stale animations.
- Store timelines in refs when external controls need stable access.

## Dependency-driven re-runs

- Use `dependencies` when animation inputs derive from props/state.
- Use `revertOnUpdate: true` when changed dependencies require a full animation rebuild.
- Avoid omitting dependencies that alter targets, trigger configuration, or animation values.

## Manual effects fallback

- If `useGSAP` cannot be used, use an isomorphic layout effect pattern and always return cleanup.
- Do not instantiate GSAP in render or memo initializers with DOM assumptions.

## Minimal example

```tsx
useGSAP(() => {
  gsap.to(".chip", { x: endX, duration: 0.4 });
}, {
  scope,
  dependencies: [endX],
  revertOnUpdate: true,
});
```
