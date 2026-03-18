# Clean Code — Modules & Organization

## Canonical docs

- https://www.typescriptlang.org/docs/handbook/2/modules.html
- _Clean Code_ ch. 10 — Classes (applied to modules)

## Module cohesion

- Each module (file) should have a single responsibility — one reason to change.
- If a module exports unrelated utilities, split it by domain.
- A good module name describes its cohesive purpose: `payment-processing.ts`, not `helpers.ts`.

## Prefer modules over classes

- TypeScript modules with exported functions are simpler and more composable than stateful classes.
- Use classes when you need encapsulated mutable state, lifecycle management, or framework integration (React class components, NestJS services).
- Avoid classes that are just bags of static methods — use a module instead.

## Barrel exports for public API

- Use `index.ts` barrel files to define the public API surface of a feature or library.
- Barrel files should contain only re-exports, no logic.
- Keep barrel files shallow (one level) to avoid circular dependency chains and bundle bloat.

```ts
// features/auth/index.ts
export { login, logout } from "./auth-service";
export { AuthProvider } from "./auth-provider";
export type { AuthState, AuthConfig } from "./auth-types";
```

## Dependency direction

- High-level modules should not depend on low-level modules; both should depend on abstractions.
- Dependencies flow inward: `UI → Application → Domain → Infrastructure interfaces`.
- Avoid circular imports — they indicate tangled responsibilities.

## Export only what's needed

- Default to keeping functions and types unexported (module-private).
- Export only the public API surface. Internal helpers stay internal.
- Prefer named exports over default exports for better refactoring support and IDE discoverability.

## File size

- Aim for ~200-300 lines per file as a soft ceiling.
- A file over 400 lines is a signal to look for extraction opportunities — but do not split arbitrarily.
- Cohesion matters more than line count.

## Colocation

- Place code near where it is used: component styles next to components, test files next to source files, types next to the functions that use them.
- Shared types and utilities live in a shared location only when genuinely used across multiple features.

## Flat directory structure

- Prefer a flat structure within feature directories. Deep nesting adds cognitive overhead without adding information.
- Two to three levels of nesting is usually sufficient: `src/features/auth/hooks/useAuth.ts`.

## Import organization

- Group imports in a consistent order: external packages, then internal aliases, then relative imports.
- Use path aliases (`@/features/auth`) to avoid deeply nested relative paths (`../../../features/auth`).

## Minimal example

```
// Bad — kitchen-sink module
// utils.ts (500 lines)
export function formatDate() { /* ... */ }
export function validateEmail() { /* ... */ }
export function calculateTax() { /* ... */ }
export function parseCSV() { /* ... */ }

// Good — cohesive modules
// date-formatting.ts
export function formatDate() { /* ... */ }
export function formatRelativeTime() { /* ... */ }

// validation.ts
export function validateEmail() { /* ... */ }
export function validatePhone() { /* ... */ }
```
