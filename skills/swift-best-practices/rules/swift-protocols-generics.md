# Swift Best Practices — Protocols & Generics

## Canonical docs

- The Swift Programming Language — Protocols, Generics
- WWDC 2022 "Embrace Swift generics"
- SE-0335: Existential `any`

## Protocol-oriented design

Prefer protocols + extensions over class inheritance for shared behavior. Define protocols for **capabilities**, not identity:

```swift
protocol Drawable {
    func draw() -> String
}

// Default implementation via extension
extension Drawable {
    func debugDraw() -> String {
        "[DEBUG] \(draw())"
    }
}
```

## some vs any

Use **`some`** (opaque type) by default — it preserves the static type identity and enables compiler optimizations:

```swift
func makeShape() -> some Shape {
    Circle()
}

// Swift 5.7+: some in parameter position
func render(_ shape: some Drawable) {
    print(shape.draw())
}
```

Use **`any`** (existential) only when you need heterogeneous collections or runtime type erasure:

```swift
// Heterogeneous collection — requires any
func renderAll(_ shapes: [any Drawable]) {
    for shape in shapes {
        print(shape.draw())
    }
}
```

**Why it matters:** `some` has zero overhead (static dispatch). `any` requires heap allocation for the existential container and uses dynamic dispatch.

## Generic constraints

Constrain generics to the minimum required protocol:

```swift
// Good — minimal constraint
func findIndex<T: Equatable>(of value: T, in array: [T]) -> Int? {
    array.firstIndex(of: value)
}

// Good — where clause for complex constraints
func merge<C: Collection>(_ lhs: C, _ rhs: C) -> [C.Element]
    where C.Element: Comparable {
    (lhs + rhs).sorted()
}
```

Prefer constrained generics over `any` for function parameters — they produce faster code and preserve type relationships.

## Protocol extensions for default behavior

Provide default implementations in protocol extensions. Be aware of the **dispatch difference**:

- **Protocol requirement** (declared in the protocol) = **dynamic dispatch** (correct override called).
- **Extension-only method** (not in the protocol) = **static dispatch** (resolved at compile time based on declared type).

```swift
protocol Greetable {
    func greet() -> String        // Protocol requirement — dynamic
}

extension Greetable {
    func greet() -> String {      // Default implementation
        "Hello!"
    }

    func shout() -> String {      // Extension-only — static dispatch
        greet().uppercased()
    }
}

struct Person: Greetable {
    func greet() -> String { "Hi, I'm a person!" }
}

let p: Greetable = Person()
p.greet()  // "Hi, I'm a person!" — dynamic dispatch, override called
p.shout()  // "HI, I'M A PERSON!" — calls greet() dynamically
```

## Associated types

Use associated types for protocols that need a placeholder type:

```swift
protocol Repository {
    associatedtype Entity: Identifiable
    func fetch(id: Entity.ID) async throws -> Entity
    func save(_ entity: Entity) async throws
}
```

Constrain associated types when needed: `associatedtype Element: Sendable`.

## Conditional conformance

Extend generic types to conform to protocols conditionally:

```swift
extension Array: Displayable where Element: Displayable {
    func display() -> String {
        map { $0.display() }.joined(separator: ", ")
    }
}
```

This is one of Swift's most powerful features — it lets you compose conformances without wrapper types.

## Avoid protocol overuse

- Don't create a protocol for every type — the "protocol with only one conformer" is a code smell.
- Protocols add indirection. Use them when you genuinely need abstraction or testability.
- A concrete type is simpler and faster when there's only one implementation.

```swift
// Unnecessary abstraction
protocol UserServiceProtocol {
    func fetchUser() async throws -> User
}
class UserService: UserServiceProtocol { ... }  // Only conformer

// Better: use the concrete type directly; extract a protocol later if needed
final class UserService {
    func fetchUser() async throws -> User { ... }
}
```
