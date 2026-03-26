# Swift Best Practices — Property Wrappers & Result Builders

## Canonical docs

- SE-0258: Property Wrappers
- SE-0289: Result Builders
- The Swift Programming Language — Property Wrappers

## Property wrappers

Property wrappers encapsulate reusable storage and access patterns. Use them to extract logic that would otherwise be duplicated across multiple properties.

Good use cases: clamping values, validation, user defaults access, thread-safe storage, logging.

```swift
@propertyWrapper
struct Clamped<Value: Comparable> {
    private var value: Value
    let range: ClosedRange<Value>

    var wrappedValue: Value {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }

    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
}

struct Player {
    @Clamped(0...100) var health: Int = 100
    @Clamped(0...999) var score: Int = 0
}
```

## Projected values

Use `projectedValue` (accessed via `$`) to expose metadata or bindings:

```swift
@propertyWrapper
struct Validated<Value> {
    var wrappedValue: Value {
        didSet { isValid = validate(wrappedValue) }
    }
    var projectedValue: Bool { isValid }  // Accessed via $property

    private var isValid: Bool
    private let validate: (Value) -> Bool

    init(wrappedValue: Value, _ validate: @escaping (Value) -> Bool) {
        self.wrappedValue = wrappedValue
        self.validate = validate
        self.isValid = validate(wrappedValue)
    }
}

struct Form {
    @Validated({ !$0.isEmpty }) var email: String = ""
}

let form = Form()
print(form.$email)  // false — projectedValue indicates validation status
```

## Framework property wrappers

Common wrappers to know:

- `@AppStorage` — persists to `UserDefaults` (not secure; never store sensitive data).
- `@SceneStorage` — state restoration for scenes.
- `@Published` — legacy observation (`ObservableObject`). Prefer `@Observable` macro in new code.

**Cross-reference:** For SwiftUI property wrappers (`@State`, `@Binding`, `@Environment`, `@Observable`, `@Bindable`), see `swiftui-expert-skill`.

## Result builders

Result builders create DSL-like syntax for building complex values declaratively:

```swift
@resultBuilder
struct HTMLBuilder {
    static func buildBlock(_ components: String...) -> String {
        components.joined(separator: "\n")
    }
    static func buildOptional(_ component: String?) -> String {
        component ?? ""
    }
    static func buildEither(first component: String) -> String {
        component
    }
    static func buildEither(second component: String) -> String {
        component
    }
}

func html(@HTMLBuilder content: () -> String) -> String {
    "<html>\n\(content())\n</html>"
}

let page = html {
    "<head><title>Hello</title></head>"
    "<body>"
    "<p>Welcome</p>"
    "</body>"
}
```

Good use cases: building HTML, constructing queries, assembling configurations, defining test fixtures.

## When not to use

- Don't use a property wrapper for something a simple computed property handles.
- Don't use a result builder when a plain initializer or function chain is clear enough.
- Don't create a property wrapper for a one-off pattern — extract only when the logic appears in 3+ places.
- If the DSL syntax doesn't meaningfully improve readability over imperative code, skip the result builder.
