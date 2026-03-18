# Clean Code — Types & Interfaces

## Canonical docs

- https://www.typescriptlang.org/docs/handbook/2/everyday-types.html
- https://www.typescriptlang.org/docs/handbook/2/narrowing.html
- https://www.typescriptlang.org/docs/handbook/utility-types.html

## Avoid `any`

- `any` disables the type checker. Every `any` is a potential runtime error waiting to happen.
- Use `unknown` when the type is genuinely unknown, then narrow with type guards before use.
- If `any` is truly unavoidable (e.g., third-party interop), add a `// eslint-disable` comment with a justification.

```ts
// Bad
function parse(input: any): any {
  return JSON.parse(input);
}

// Good
function parse(input: string): unknown {
  return JSON.parse(input);
}

function isUser(value: unknown): value is User {
  return typeof value === "object" && value !== null && "id" in value;
}
```

## Discriminated unions

- Model variant types with a shared literal discriminant field.
- This enables exhaustive pattern matching and eliminates whole classes of invalid state.

```ts
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "rectangle"; width: number; height: number };

function area(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "rectangle":
      return shape.width * shape.height;
    default:
      return assertNever(shape);
  }
}

function assertNever(value: never): never {
  throw new Error(`Unexpected value: ${JSON.stringify(value)}`);
}
```

## Type guards over assertions

- Prefer user-defined type guards (`value is T`) and narrowing over type assertions (`as T`).
- Type assertions bypass the compiler; type guards work with it.
- Reserve `as` for situations where you have provably more information than the compiler (e.g., DOM element references).

## Utility types

- Use built-in utility types to derive related types instead of duplicating definitions.
- `Partial<T>`, `Required<T>`, `Pick<T, K>`, `Omit<T, K>`, `Record<K, V>`, `Readonly<T>`.
- Derive update/create types from the base type: `type CreateUser = Omit<User, "id" | "createdAt">`.

## Interface vs type alias

- Use `interface` for object shapes that may be extended or implemented.
- Use `type` for unions, intersections, mapped types, and computed types.
- Be consistent within a project — pick one convention for simple object shapes and stick to it.

## Constrained generics

- Generic type parameters should have meaningful names (`TItem`, not `T` when ambiguity exists).
- Always constrain generics when possible: `<T extends Identifiable>` over bare `<T>`.
- Avoid generics when a concrete type or union suffices.

## `as const` over enums

- Prefer `as const` objects for enum-like values — they produce narrower literal types and work with standard object utilities.
- Numeric enums are acceptable for bit flags. String enums are acceptable when interoperating with APIs that expect them.

```ts
// Preferred
const Status = {
  Active: "active",
  Inactive: "inactive",
  Suspended: "suspended",
} as const;
type Status = (typeof Status)[keyof typeof Status];

// Acceptable for API interop
enum HttpMethod {
  GET = "GET",
  POST = "POST",
}
```

## Minimal example

```ts
// Bad — any, assertion, no narrowing
function getUser(response: any): User {
  return response.data as User;
}

// Good — unknown, guard, narrowing
function getUser(response: unknown): User {
  if (!isApiResponse(response)) {
    throw new InvalidResponseError(response);
  }
  return response.data;
}
```
