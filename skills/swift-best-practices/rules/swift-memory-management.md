# Swift Best Practices — Memory Management

## Canonical docs

- The Swift Programming Language — Automatic Reference Counting
- Apple Developer: Diagnosing memory issues

## ARC basics

Swift uses **Automatic Reference Counting** for class instances. Each strong reference increments the count; the instance is deallocated when the count reaches zero.

- Value types (structs, enums) are **not** reference-counted.
- Every class property, variable, or closure capture is a **strong reference** by default.

## Retain cycles

Two objects holding strong references to each other prevent deallocation — a **retain cycle** (memory leak). Most common patterns:

1. **Delegate stored as strong reference.**
2. **Closure property on a class that captures `self`.**
3. **Timer or observer retaining its owner.**
4. **Parent-child relationships where both hold strong references.**

```swift
// BAD: Retain cycle — each keeps the other alive
class Person {
    var apartment: Apartment?
}
class Apartment {
    var tenant: Person?  // Strong reference back
}
```

## weak vs unowned

**`weak`** — optional reference, becomes `nil` when the target is deallocated:

```swift
class Apartment {
    weak var tenant: Person?  // Does not prevent deallocation
}

protocol DataDelegate: AnyObject { ... }
class DataManager {
    weak var delegate: DataDelegate?  // Always weak for delegates
}
```

**`unowned`** — non-optional reference, crashes if accessed after the target is deallocated:

```swift
class Course {
    unowned var department: Department  // Department always outlives Course
}
```

**Decision tree:**

| Scenario | Use |
|---|---|
| Reference might outlive the target | `weak` |
| Reference has same or shorter lifetime, and you can prove it | `unowned` |
| Uncertain about lifetimes | `weak` (safer default) |

## Closures and capture lists

Escaping closures capture `self` **strongly** by default. Use capture lists to break cycles:

```swift
class ViewController {
    var data: Data?

    func loadData() {
        // [weak self] prevents retain cycle
        networkService.fetch { [weak self] result in
            guard let self else { return }
            self.data = result
        }
    }
}
```

### When [weak self] is NOT needed

- **Non-escaping closures** — cannot create a cycle (`map`, `filter`, `forEach`, `compactMap`).
- **Closures not stored** by the object — short-lived completions where `self` cannot be deallocated.
- **Value types** — structs cannot form reference cycles.

```swift
// UNNECESSARY: map's closure is non-escaping
let names = users.map { [weak self] user in  // Don't do this
    self?.format(user.name)
}

// CORRECT: non-escaping closures don't need weak self
let names = users.map { user in
    format(user.name)
}
```

### Avoid [unowned self] in closures

`[unowned self]` is equivalent to force-unwrapping `self`. If `self` is deallocated before the closure runs, it crashes. Use only with a documented lifetime guarantee:

```swift
// DANGEROUS — crash if self is deallocated before timer fires
timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [unowned self] _ in
    self.refresh()
}

// SAFER
timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
    self?.refresh()
}
```

## Common retain cycle fixes

| Pattern | Problem | Fix |
|---|---|---|
| Delegate | Strong reference to delegate | Mark `weak var delegate` |
| Closure property | `self.handler = { self.doWork() }` | `{ [weak self] in self?.doWork() }` |
| Timer target | Timer retains its target | Block-based API + `[weak self]` |
| NotificationCenter | Observer closure captures self | `[weak self]` in closure; remove observer in `deinit` |

## Detecting leaks

- **Xcode Memory Graph Debugger** — shows live object graph and highlights leaks.
- **Instruments Leaks template** — runtime leak detection.
- **Add `deinit` logging** during development:

```swift
deinit {
    print("\(type(of: self)) deallocated")
}
```

## Cross-reference

- For memory management in async tasks and actor-isolated code, see `swift-concurrency` skill, `references/memory-management.md`.
