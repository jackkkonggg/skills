# Clean Code — Error Handling

## Canonical docs

- https://www.typescriptlang.org/docs/handbook/2/narrowing.html#using-type-predicates
- _Clean Code_ ch. 7 — Error Handling

## Exceptions over error codes

- Use exceptions for unexpected failures (network errors, invariant violations).
- Use typed return values (`Result<T, E>` or `T | undefined`) for expected, recoverable failures (validation, "not found" lookups).
- Do not use `null` as a general-purpose error signal.

## Custom error classes

- Extend `Error` for domain-specific error types.
- Include contextual information (what failed, relevant IDs, original cause).

```ts
class OrderNotFoundError extends Error {
  constructor(public readonly orderId: string) {
    super(`Order not found: ${orderId}`);
    this.name = "OrderNotFoundError";
  }
}
```

## Never swallow errors

- Every `catch` block must log, re-throw, wrap, or return a typed failure.
- An empty `catch {}` is always a bug.

```ts
// Bad
try {
  await saveOrder(order);
} catch {
  // silently ignored
}

// Good
try {
  await saveOrder(order);
} catch (error: unknown) {
  logger.error("Failed to save order", { orderId: order.id, error });
  throw new OrderPersistenceError(order.id, { cause: error });
}
```

## Use `unknown` in catch clauses

- TypeScript's `catch` variable is `unknown` by default (with `useUnknownInCatchVariables`).
- Always narrow before accessing properties: `if (error instanceof Error)`.

## Don't return null for errors

- Prefer `T | undefined` for "not found" semantics.
- For operations that can fail in multiple ways, use a discriminated union result type.

```ts
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

function findUser(id: string): Result<User, UserLookupError> {
  // ...
}
```

## Catch at system boundaries

- Handle errors at the boundary where you can take meaningful action (API handler, event listener, top-level orchestrator).
- Let errors propagate through intermediate layers without catch-and-rethrow noise.
- Framework error boundaries (React error boundaries, Express error middleware) are the right place for catch-all handling.

## Fail fast

- Validate preconditions early and throw immediately when invariants are violated.
- Guard clauses at the top of a function are clearer than deeply nested conditionals.

```ts
function processPayment(order: Order): PaymentResult {
  if (!order.items.length) {
    throw new InvalidOrderError("Cannot process empty order");
  }
  if (!order.paymentMethod) {
    throw new InvalidOrderError("Payment method required");
  }

  // Happy path continues without nesting
  return chargePaymentMethod(order);
}
```

## Minimal example

```ts
// Bad — returns null, catches any, no context
function getConfig(key: string): Config | null {
  try {
    return loadConfig(key);
  } catch (e: any) {
    console.log(e.message);
    return null;
  }
}

// Good — Result type, unknown catch, structured logging
function getConfig(key: string): Result<Config, ConfigError> {
  try {
    const config = loadConfig(key);
    return { success: true, data: config };
  } catch (error: unknown) {
    logger.warn("Config load failed", { key, error });
    return { success: false, error: new ConfigError(key, { cause: error }) };
  }
}
```
