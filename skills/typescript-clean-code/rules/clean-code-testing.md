# Clean Code — Testing

## Canonical docs

- https://vitest.dev/guide/
- https://jestjs.io/docs/getting-started
- _Clean Code_ ch. 9 — Unit Tests

## F.I.R.S.T. principles

- **Fast** — Tests should run in milliseconds. Mock I/O, databases, and network calls.
- **Independent** — No test should depend on another test's state or execution order.
- **Repeatable** — Same result in any environment (CI, local, colleague's machine).
- **Self-validating** — Pass or fail with no manual inspection of output.
- **Timely** — Write tests close to the time you write the production code.

## One concept per test

- Each test should verify one behavior or invariant.
- Multiple assertions are fine if they all verify the same concept.
- If a test name contains "and", consider splitting it.

## Arrange-Act-Assert (AAA)

- Structure every test in three clear sections, optionally separated by blank lines.
- **Arrange**: Set up inputs and expected outputs.
- **Act**: Call the function or trigger the behavior under test.
- **Assert**: Verify the result.

```ts
it("returns the total price including tax", () => {
  const order = createOrder({ items: [{ price: 100, quantity: 2 }] });

  const total = calculateTotal(order, { taxRate: 0.1 });

  expect(total).toBe(220);
});
```

## Behavior-describing test names

- Test names should read as specifications: describe *what* the system does, not *how*.
- Use the pattern: `"<unit> <does something> when <condition>"`.

```ts
// Bad
it("test1", () => { /* ... */ });
it("should work", () => { /* ... */ });

// Good
it("rejects orders with no items", () => { /* ... */ });
it("applies discount when coupon is valid", () => { /* ... */ });
```

## Test the public interface

- Test behavior through the public API, not internal implementation details.
- Avoid testing private methods directly — they are exercised through the public interface.
- If you feel the need to test a private method, it may belong in its own module.

## Typed test utilities

- Do not use `as any` or type assertions in test setup — they hide the exact contract under test.
- Create typed factory functions or builders for test data.

```ts
// Bad
const user = { name: "Alice" } as any as User;

// Good
function createTestUser(overrides?: Partial<User>): User {
  return {
    id: "test-id",
    name: "Alice",
    email: "alice@example.com",
    isActive: true,
    ...overrides,
  };
}
```

## Avoid test smells

- **Conditional logic in tests** — Tests with `if`/`else` are testing multiple paths and hiding failures.
- **Test interdependence** — Shared mutable state between tests causes flaky failures.
- **Testing implementation** — Asserting on internal method calls instead of observable behavior makes tests brittle to refactoring.
- **Giant test setups** — If arrange is 50 lines, extract a builder or move setup to `beforeEach`.

## Minimal example

```ts
// Bad — multiple concepts, no structure, any cast
it("should work", () => {
  const svc = new Service({} as any);
  const r1 = svc.process("valid");
  expect(r1).toBeTruthy();
  const r2 = svc.process("");
  expect(r2).toBeFalsy();
  expect(svc.getCount()).toBe(1);
});

// Good — one concept, AAA, typed setup
describe("OrderService.process", () => {
  it("accepts valid order input", () => {
    const service = createTestService();

    const result = service.process(validOrderInput);

    expect(result.success).toBe(true);
  });

  it("rejects empty input", () => {
    const service = createTestService();

    const result = service.process("");

    expect(result.success).toBe(false);
    expect(result.error).toBeInstanceOf(ValidationError);
  });
});
```
