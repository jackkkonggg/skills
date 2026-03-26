# Swift Best Practices — Optionals

## Canonical docs

- The Swift Programming Language — Optionals
- Swift API Design Guidelines

## guard let for early exit

Use `guard let` when the unwrapped value is needed for the **rest of the scope**. This keeps the happy path unindented and exits early on failure.

```swift
func process(data: Data?) {
    guard let data else {
        log("No data provided")
        return
    }
    // data is guaranteed non-nil for the remainder
    parse(data)
}
```

## if let for scoped usage

Use `if let` when the unwrapped value is only needed **inside the conditional block**.

```swift
if let name = person.name {
    greet(name)
}
// name is not needed after this point
```

Swift 5.7+ shorthand — omit the right-hand side when shadowing:

```swift
if let name {
    greet(name)
}
```

## Nil-coalescing operator

Use `??` to provide a default value:

```swift
let title = optionalTitle ?? "Untitled"
let count = items?.count ?? 0
```

Avoid deeply nested `??` chains. If you have more than two fallbacks, extract to a computed property or function.

## Optional chaining

Use `?.` for safe property and method access on optional values:

```swift
let street = user?.address?.street
let uppercased = optionalString?.uppercased()
```

Combine with nil-coalescing for concise defaults:

```swift
let displayName = user?.name ?? "Anonymous"
```

## map and flatMap on optionals

Use `.map` to transform an optional value without unwrapping manually:

```swift
// Instead of:
let parsed: Int?
if let string = optionalString {
    parsed = Int(string)
} else {
    parsed = nil
}

// Use:
let parsed = optionalString.map { Int($0) }  // Optional<Optional<Int>>
let parsed = optionalString.flatMap { Int($0) }  // Optional<Int>
```

Use `.flatMap` when the transform itself returns an optional, to avoid nested optionals.

## When force-unwrap is acceptable

Force-unwrap (`!`) must only be used when:

1. **After a fatalError-documented precondition** — the nil case represents a programmer error, not a runtime condition.
2. **IBOutlets** in UIKit/AppKit — set by Interface Builder before use.
3. **In unit tests** — where failure indicates a broken test, not a runtime issue.

Always add a comment explaining **why** the force-unwrap is safe:

```swift
// Safe: we just checked contains() above
let index = array.firstIndex(of: element)!
```

## Implicitly unwrapped optionals

Reserve `Type!` declarations for:

- `@IBOutlet` properties (set by Interface Builder).
- Two-phase initialization patterns where a value is guaranteed before first access.

Never use as a general-purpose substitute for proper optionals.

## Avoid the pyramid of doom

```swift
// Bad — nested unwrapping
if let a = optA {
    if let b = optB {
        if let c = optC {
            use(a, b, c)
        }
    }
}

// Good — flat guard chain
guard let a = optA, let b = optB, let c = optC else {
    return
}
use(a, b, c)
```
