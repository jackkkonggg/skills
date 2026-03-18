# TypeScript Clean Code (Agent Rules)

This is the fast-path playbook. Use it to make decisions quickly, then consult the section files for exact patterns and examples.

## Non-negotiables

- Never use `any` without a written justification comment; prefer `unknown` with type narrowing.
- Functions must do one thing — if you need "and" to describe it, split it.
- Never swallow errors silently; always log, re-throw, or return a typed failure.
- No magic literals — extract to named constants or enums/`as const` objects.
- Add JSDoc on all public API exports (functions, classes, types that cross module boundaries).
- Prefer discriminated unions and type guards over type assertions (`as`).

## Core defaults

- Use intent-revealing names: a reader should understand purpose without reading the implementation.
- Keep functions to ~5-20 lines; extract when a function exceeds this or operates at mixed abstraction levels.
- Favor composition and modules over class inheritance hierarchies.
- Mark data that should not change as `readonly` (properties, arrays, parameters).
- Use exhaustive `switch`/`if-else` with `never` checks on discriminated unions.
- Limit function parameters to 3 or fewer; use an options object for more.
- Model expected failures with `Result<T, E>` or `T | undefined` patterns instead of null returns or thrown exceptions for control flow.
- Use barrel (`index.ts`) exports to define clear public API surfaces; keep internal modules unexported.
- Write one concept per test, use behavior-describing names, and follow Arrange-Act-Assert structure.

## Full references

- `rules/clean-code-naming.md`
- `rules/clean-code-functions.md`
- `rules/clean-code-types-interfaces.md`
- `rules/clean-code-error-handling.md`
- `rules/clean-code-modules-organization.md`
- `rules/clean-code-testing.md`
- `rules/clean-code-comments-docs.md`
- `rules/clean-code-smells.md`
