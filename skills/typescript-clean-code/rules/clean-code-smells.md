# Clean Code — TypeScript-Specific Smells

## Canonical docs

- https://www.typescriptlang.org/docs/handbook/2/types-from-types.html
- _Clean Code_ ch. 17 — Smells and Heuristics

## Type assertion abuse

- Excessive `as` casts bypass the compiler and hide type mismatches.
- Each `as` assertion is a bet that you know better than the type checker — and bets can be wrong at runtime.
- **Fix**: Narrow with type guards, refine types, or restructure data flow.

```ts
// Smell
const name = (data as any).user.name as string;

// Clean
if (isUserResponse(data)) {
  const name = data.user.name;
}
```

## `any` leakage

- A single `any` infects every type that touches it, silently disabling type checking across module boundaries.
- **Fix**: Use `unknown` at ingestion points, narrow immediately, and ensure no `any` leaks into function signatures or return types.

## Enum misuse

- TypeScript enums have surprising runtime behavior (reverse mappings, numeric auto-increment, cross-file bundling issues).
- **Fix**: Prefer `as const` objects with derived union types for most use cases. Reserve enums for bit flags or explicit API contracts.

## Class overuse

- Classes with no mutable state and only static methods are modules in disguise.
- Classes with a single method are functions in disguise.
- **Fix**: Use plain functions and modules. Reserve classes for genuinely stateful entities.

## Barrel file bloat

- Barrel files (`index.ts`) that re-export everything from every submodule create circular dependencies and defeat tree-shaking.
- **Fix**: Barrel files should export only the public API. Keep them shallow (one level deep). Prefer direct imports for internal module-to-module references.

## Premature abstraction

- Abstracting before you have three concrete use cases often produces the wrong abstraction, which is harder to undo than duplication.
- **Fix**: Follow the "Rule of Three" — duplicate first, then extract when the pattern is clear and stable.

## Boolean blindness

- Functions that accept or return naked booleans force callers to remember positional meaning.
- **Fix**: Use named options objects, string literal unions, or descriptive wrapper types.

```ts
// Smell
createUser("Alice", true, false, true);

// Clean
createUser({
  name: "Alice",
  isAdmin: true,
  sendWelcomeEmail: false,
  requireMfa: true,
});
```

## Stringly-typed code

- Using raw strings where a finite set of values is expected loses type safety.
- **Fix**: Use string literal unions, discriminated unions, or `as const` objects.

```ts
// Smell
function setTheme(theme: string): void { /* ... */ }

// Clean
type Theme = "light" | "dark" | "system";
function setTheme(theme: Theme): void { /* ... */ }
```

## Mutable shared state

- Global or module-level mutable variables create hidden coupling, make testing difficult, and invite race conditions in async code.
- **Fix**: Pass state explicitly via function parameters or dependency injection. Use `readonly` for data structures that should not be mutated after creation.

## Inconsistent error handling patterns

- Mixing thrown exceptions, null returns, error codes, and Result types across a codebase forces callers to guess the contract.
- **Fix**: Establish one primary pattern per layer (e.g., Result types in domain logic, exceptions at system boundaries) and document it in a team convention.

## God modules

- A file that imports from many unrelated modules and exports many unrelated functions is a code smell indicating low cohesion.
- **Fix**: Split by domain responsibility. Each module should have one reason to change.

## Minimal example

```ts
// Smell — multiple issues
const cfg: any = loadConfig();
const MODE = cfg.mode as string;

class Utils {
  static format(d: any) { return String(d); }
  static parse(s: string) { return JSON.parse(s); }
}

export function init(verbose: boolean, dry: boolean) {
  if (MODE === "prod") { /* ... */ }
}

// Clean — addressed
interface AppConfig {
  mode: "development" | "production" | "test";
}

const config: AppConfig = loadAndValidateConfig();

export function formatValue(value: unknown): string {
  return String(value);
}

export function parseJson(raw: string): unknown {
  return JSON.parse(raw);
}

interface InitOptions {
  verbose: boolean;
  dryRun: boolean;
}

export function init(options: InitOptions): void {
  if (config.mode === "production") { /* ... */ }
}
```
