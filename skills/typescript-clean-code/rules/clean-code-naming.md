# Clean Code — Naming

## Canonical docs

- https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html
- _Clean Code_ ch. 2 — Meaningful Names

## Reveal intent

- Names should answer why something exists, what it does, and how it is used.
- If a name requires a comment to explain it, the name is insufficient.

```ts
// Bad
const d: number = 0; // elapsed time in days

// Good
const elapsedDays: number = 0;
```

## Avoid disinformation

- Do not use names that carry implicit but inaccurate meaning.
- Do not suffix a variable `List` unless it is actually a list; prefer `accounts` over `accountList`.
- Avoid names that differ only in subtle ways (`XYZControllerForHandlingOfStrings` vs `XYZControllerForStorageOfStrings`).

## Make meaningful distinctions

- Do not use noise words (`Data`, `Info`, `Manager`, `Processor`) unless they carry genuine domain meaning.
- `getActiveAccounts()` is better than `getAccounts2()` or `getAccountData()`.

## Use pronounceable, searchable names

- Full words over abbreviations (`timestamp` not `ts`, `configuration` not `cfg`).
- Single-letter names only for short lambda parameters or loop indices.

## Casing conventions

- `PascalCase` for classes, interfaces, type aliases, and enums.
- `camelCase` for functions, methods, variables, and properties.
- `UPPER_SNAKE_CASE` for module-level constants that are true compile-time values.
- Prefix booleans with `is`, `has`, `should`, `can`, or `was` to read as predicates.

## TypeScript-specific

- Do not prefix interfaces with `I` — prefer `User` over `IUser`.
- Do not use Hungarian notation or type encodings in names (`strName`, `numCount`).
- Use a consistent vocabulary per concept — don't mix `fetch`, `get`, `retrieve` for the same kind of operation.

## Minimal example

```ts
// Bad
interface IData {
  strN: string;
  flg: boolean;
  lst: string[];
}

function proc(d: IData): void { /* ... */ }

// Good
interface UserProfile {
  displayName: string;
  isVerified: boolean;
  permissions: string[];
}

function renderUserProfile(profile: UserProfile): void { /* ... */ }
```
