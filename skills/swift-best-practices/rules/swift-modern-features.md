# Swift Best Practices — Modern Swift Features

## Canonical docs

- SE-0382: Expression Macros (Swift 5.9)
- SE-0393: Parameter Packs (Swift 5.9)
- SE-0390: Noncopyable Types (Swift 5.9, enhanced in 6.0)
- SE-0377: borrowing and consuming (Swift 5.9)
- The Swift Programming Language — Macros

## Macros (Swift 5.9+)

**Freestanding macros** (`#`) generate code inline:

```swift
// Standard library / framework examples
func myFunction() {
    print("Running \(#function)")
    #warning("TODO: implement error handling")
}

// Foundation #Predicate macro
let isAdult = #Predicate<Person> { $0.age >= 18 }
```

**Attached macros** (`@`) modify the declarations they are attached to:

```swift
// @Observable replaces ObservableObject + @Published boilerplate
@Observable
class UserSettings {
    var username = ""
    var isLoggedIn = false
}

// @Model (SwiftData) generates persistence code
@Model
class Trip {
    var name: String
    var destination: String
}
```

Prefer existing macros over manual boilerplate. Create custom macros only for patterns repeated across many files — macros use SwiftSyntax and add build complexity.

## Parameter packs (Swift 5.9+)

Enable variadic generics — functions that accept an arbitrary number of differently-typed arguments:

```swift
func all<each T>(_ optional: repeat (each T)?) -> (repeat each T)? {
    (repeat try (each optional).unsafelyUnwrapped)  // simplified
}

// Usage
if let (name, age, email) = all(optName, optAge, optEmail) {
    register(name: name, age: age, email: email)
}
```

Use parameter packs to eliminate overloaded function sets (e.g., `zip2`, `zip3`, `zip4`).

## Noncopyable types (Swift 5.9+)

Types annotated with `~Copyable` cannot be implicitly copied. Use for unique resources with exclusive ownership:

```swift
struct FileDescriptor: ~Copyable {
    private let fd: Int32

    init(descriptor: Int32) { self.fd = descriptor }

    consuming func close() {
        // close(fd)
    }

    deinit {
        // Auto-close if not consumed
    }
}
```

In Swift 6.0, noncopyable types work with generics:

```swift
func useOnce<T: ~Copyable>(_ value: consuming T) {
    // value is consumed; caller can no longer use it
}
```

## Ownership: consuming and borrowing (Swift 5.9+)

Explicitly declare how functions interact with parameter ownership:

- **`borrowing`** — callee reads without taking ownership; no copy is made.
- **`consuming`** — callee takes ownership; caller must not use the value afterward.

```swift
struct LargeBuffer: ~Copyable {
    var data: [UInt8]

    borrowing func peek() -> UInt8 {
        data[0]  // Read-only access
    }

    consuming func release() -> [UInt8] {
        data  // Ownership transferred to caller
    }
}
```

Use in performance-critical code to avoid unnecessary copies. For most code, the compiler's default ownership inference is sufficient.

## if/switch expressions (Swift 5.9+)

`if` and `switch` can be used as expressions that return values:

```swift
let icon = if isEnabled { "checkmark" } else { "xmark" }

let description = switch status {
    case .active: "Active"
    case .inactive: "Inactive"
    case .suspended: "Suspended"
}
```

Cleaner than temporary variables or multi-line ternary operators for multi-branch assignment.

## Regex builder (Swift 5.7+)

Use `Regex { }` builder syntax for complex patterns instead of opaque string literals:

```swift
import RegexBuilder

let dateRegex = Regex {
    Capture { OneOrMore(.digit) }      // year
    "-"
    Capture { Repeat(.digit, count: 2) }  // month
    "-"
    Capture { Repeat(.digit, count: 2) }  // day
}

if let match = "2025-03-15".firstMatch(of: dateRegex) {
    let (_, year, month, day) = match.output
}
```

Use string regex literals (`/pattern/`) for simple patterns; use the builder for complex, multi-part patterns that benefit from named captures and composition.

## Cross-reference

- For `@Observable` integration with SwiftUI views, see `swiftui-expert-skill`.
- For Swift 6 concurrency safety (`Sendable`, actors, `@concurrent`), see `swift-concurrency` skill.
