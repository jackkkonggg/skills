# React GSAP Rules (Setup)

## Canonical docs

- https://github.com/greensock/react
- https://gsap.com/resources/react-basics/
- https://react.dev/reference/react/useRef

## Baseline setup

- Import `useGSAP` from `@gsap/react` and register it as a GSAP plugin once.
- Use a container ref and pass it as `scope` to `useGSAP` for selector safety.
- Prefer refs for animated elements rather than global selector strings.
- Keep animation creation inside `useGSAP` callback, not during render.
- Prefer the config-object form of `useGSAP` (`{ scope, dependencies, revertOnUpdate }`) for consistent lifecycle control.

## Context-safe callbacks

- Wrap event handlers, timers, and async callbacks that create GSAP objects with `contextSafe()`.
- Remove event listeners in teardown when manually attached.
- Avoid creating unmanaged tweens in callbacks outside GSAP context.
- Use either `const { contextSafe } = useGSAP({ scope })` or the callback second argument pattern when wiring listeners.

## Minimal example

```tsx
import { useRef } from "react";
import gsap from "gsap";
import { useGSAP } from "@gsap/react";

gsap.registerPlugin(useGSAP);

export function Hero() {
  const scope = useRef<HTMLDivElement | null>(null);

  useGSAP(() => {
    gsap.from(".headline", { y: 24, autoAlpha: 0, duration: 0.5 });
  }, { scope });

  return <section ref={scope}><h1 className="headline">Hello</h1></section>;
}
```
