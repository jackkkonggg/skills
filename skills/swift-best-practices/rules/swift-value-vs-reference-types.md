# Swift Best Practices — Value Types vs Reference Types

## Canonical docs

- WWDC 2015 "Building Better Apps with Value Types in Swift"
- The Swift Programming Language — Structures and Classes

## Default to structs

Use structs for data models, DTOs, configuration objects, and domain entities. Structs provide **value semantics**: copies are independent, there is no shared mutable state, and they are inherently thread-safe.

```swift
// Preferred: value type
struct Coordinate {
    var x: Double
    var y: Double
}

var a = Coordinate(x: 1, y: 2)
var b = a       // independent copy
b.x = 10       // a.x is still 1
```

Value types in arrays avoid NSArray bridging overhead and eliminate retain/release traffic when they contain no reference types.

## When to use classes

Use classes only when you need:

- **Identity** — two variables must refer to the same instance (e.g., shared resources).
- **Inheritance** — `UIViewController`, `NSObject` subclasses, framework requirements.
- **Deinit** — cleanup logic when the instance is deallocated (file handles, network connections).
- **Objective-C interop** — APIs that require reference types.

```swift
// Reference semantics required — shared, identity-dependent resource
class DatabaseConnection {
    private var handle: OpaquePointer?

    deinit {
        close()
    }
}
```

## Value semantics checklist

A type has value semantics when:

- `==` compares **content**, not identity.
- Copies are **independent** — mutating a copy does not affect the original.
- The type is **thread-safe by default** (no shared mutable state).

If your struct contains reference-type properties, ensure they are either immutable or use copy-on-write to preserve value semantics.

## Enums for finite state

Prefer enums with associated values over stringly-typed or boolean state:

```swift
// Bad — boolean soup
var isLoading = true
var hasError = false
var data: Data?

// Good — exhaustive, self-documenting
enum LoadingState {
    case idle
    case loading
    case loaded(Data)
    case failed(Error)
}
```

Use enums **without cases** as namespaces to prevent accidental instantiation:

```swift
enum API {
    enum Endpoints {
        static let users = "/api/v1/users"
        static let posts = "/api/v1/posts"
    }
}
```

## Copy-on-write (COW)

Swift's standard collections (`Array`, `Dictionary`, `Set`) use COW: memory is shared until mutation. Only then is a copy made.

- Prefer **in-place mutation** (`array.append(x)`) over creating new copies (`array + [x]`).
- Use `reserveCapacity(_:)` when the final size is known.

For custom large value types that are copied frequently, implement manual COW:

```swift
final class StorageRef<T> {
    var value: T
    init(_ value: T) { self.value = value }
}

struct LargeBuffer {
    private var storage: StorageRef<[UInt8]>

    var data: [UInt8] {
        get { storage.value }
        set {
            if !isKnownUniquelyReferenced(&storage) {
                storage = StorageRef(newValue)
            } else {
                storage.value = newValue
            }
        }
    }
}
```
