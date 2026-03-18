# Clean Code — Comments & Documentation

## Canonical docs

- https://tsdoc.org/
- _Clean Code_ ch. 4 — Comments

## Self-documenting code first

- The best comment is a well-named function, variable, or type.
- Before adding a comment, ask: can I rename or restructure to make this obvious?

```ts
// Bad — comment compensates for poor naming
// Check if the user is eligible for a discount
if (u.a > 1 && u.o >= 5) { /* ... */ }

// Good — code speaks for itself
const isEligibleForDiscount = user.accountAgeYears > 1 && user.orderCount >= 5;
if (isEligibleForDiscount) { /* ... */ }
```

## Good comments

- **Intent / "why"** — Explain non-obvious business rules, design tradeoffs, or workarounds.
- **Warnings** — `// HACK:`, `// WORKAROUND:` with context on why the hack exists and when it can be removed.
- **TODO with tickets** — `// TODO(JIRA-123): migrate to new payment API` — always link to a tracking issue.
- **JSDoc on public exports** — Document parameters, return values, exceptions, and usage examples for functions and types that cross module boundaries.
- **Legal / license headers** — When required by policy.

```ts
/**
 * Calculates the shipping cost based on destination zone and package weight.
 *
 * Uses the carrier's volumetric weight formula when it exceeds actual weight.
 *
 * @param destination - ISO 3166-1 alpha-2 country code
 * @param weightKg - Actual weight in kilograms
 * @returns Shipping cost in USD cents
 * @throws {UnsupportedDestinationError} When the country is not in our shipping zones
 */
export function calculateShipping(destination: string, weightKg: number): number {
  // ...
}
```

## Bad comments

- **Restating the code** — `i += 1; // increment i` adds noise, not clarity.
- **Journal comments** — Changelogs belong in git history, not in source files.
- **Commented-out code** — Delete it. Version control remembers. Commented code rots and confuses readers.
- **Closing-brace comments** — `} // end if` indicates the block is too long; shorten it instead.
- **Attribution comments** — `// Added by Alice` belongs in `git blame`.
- **Mandated boilerplate** — Do not add comments just to satisfy a "every function must have a comment" rule.

## Types as documentation

- TypeScript types are living, compiler-verified documentation.
- Prefer expressing constraints through the type system over documenting them in prose.

```ts
// Bad — comment-documented constraint
/** status must be "active", "inactive", or "suspended" */
function setStatus(status: string): void { /* ... */ }

// Good — type-documented constraint
type UserStatus = "active" | "inactive" | "suspended";
function setStatus(status: UserStatus): void { /* ... */ }
```

## JSDoc scope

- Write JSDoc for exported functions, classes, and type aliases.
- Internal / private helpers rarely need JSDoc — a clear name is sufficient.
- Keep descriptions concise; avoid repeating what the type signature already tells you.

## Minimal example

```ts
// Bad — noisy, redundant comments
// This function gets the user
// @param id - the id
// @returns the user
function getUser(id: string): User {
  // Get user from database
  const user = db.find(id); // find user
  return user; // return user
}

// Good — self-documenting with targeted JSDoc
/**
 * Retrieves a user by ID, returning `undefined` if not found.
 *
 * @throws {DatabaseConnectionError} When the database is unreachable
 */
function findUser(id: string): User | undefined {
  return db.find(id);
}
```
