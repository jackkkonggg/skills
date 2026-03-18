# Clean Code — Functions

## Canonical docs

- https://www.typescriptlang.org/docs/handbook/2/functions.html
- _Clean Code_ ch. 3 — Functions

## Small functions

- Aim for 5-20 lines per function. Extract when a function grows beyond this range.
- A function that fits on one screen without scrolling is easier to reason about.

## Do one thing

- A function should perform one task, at one level of abstraction.
- If you need the word "and" to describe what a function does, it should be two functions.

## One level of abstraction per function

- Do not mix high-level orchestration with low-level implementation details in the same function body.
- Extract lower-level steps into well-named helper functions.

```ts
// Bad — mixed abstraction levels
function processOrder(order: Order): void {
  // validation logic (low level)
  if (!order.items.length) throw new Error("Empty order");
  if (order.total < 0) throw new Error("Negative total");
  // orchestration (high level)
  chargePayment(order);
  sendConfirmation(order);
}

// Good — uniform abstraction
function processOrder(order: Order): void {
  validateOrder(order);
  chargePayment(order);
  sendConfirmation(order);
}
```

## Few arguments

- Ideal: 0-2 arguments. Acceptable: 3. More than 3: use an options object.
- Boolean flag arguments signal the function does more than one thing — prefer two separate functions.

```ts
// Bad
function createUser(name: string, email: string, role: string, isActive: boolean, sendWelcome: boolean): User { /* ... */ }

// Good
interface CreateUserOptions {
  name: string;
  email: string;
  role: string;
  isActive?: boolean;
  sendWelcome?: boolean;
}

function createUser(options: CreateUserOptions): User { /* ... */ }
```

## No hidden side effects

- A function named `checkPassword` should not also initialize a session.
- Side effects (mutations, I/O) should be explicit in the function name or clearly documented.

## Command-query separation

- A function should either change state (command) or return information (query), not both.
- Exceptions are acceptable for atomic operations (e.g., `Map.set` returning the map).

## Prefer pure functions

- Functions that depend only on their inputs and produce no side effects are easier to test and reason about.
- Isolate impure operations (I/O, randomness, current time) at the edges of your system.

## Arrow functions vs declarations

- Use function declarations for top-level exports and named functions.
- Use arrow functions for callbacks, inline handlers, and short expressions.
- Be consistent within a module.

## Minimal example

```ts
// Bad
function handle(data: unknown, flag: boolean, retries: number): unknown {
  // 50 lines mixing parsing, validation, API calls, and formatting
}

// Good
function parseInput(raw: unknown): OrderRequest {
  // 8 lines — parsing only
}

function submitOrder(request: OrderRequest): OrderResult {
  // 12 lines — orchestration only
}
```
