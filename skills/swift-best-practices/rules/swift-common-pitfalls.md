# Swift Best Practices — Common Pitfalls

## Canonical docs

- Swift API Design Guidelines
- The Swift Programming Language

This file catalogs the most frequent Swift anti-patterns. Each includes the problem, why it matters, and the fix.

## 1. Force unwrapping optionals

Force-unwrapping (`!`) is the leading cause of Swift runtime crashes.

```swift
// Bad
let name = user.name!

// Good
guard let name = user.name else { return }
```

See `rules/swift-optionals.md` for the complete safe-unwrapping guide.

## 2. Retain cycles in closures

Escaping closures that capture `self` strongly on reference types create memory leaks:

```swift
// Bad — retain cycle
networkService.fetch { result in
    self.data = result
}

// Good — weak capture
networkService.fetch { [weak self] result in
    self?.data = result
}
```

See `rules/swift-memory-management.md` for the full decision tree.

## 3. Overusing [weak self]

Using `[weak self]` everywhere — including non-escaping closures — adds noise and nil-checking overhead with no benefit:

```swift
// Unnecessary — map is non-escaping
let names = users.map { [weak self] user in
    self?.format(user.name)  // Now returns Optional unnecessarily
}

// Correct
let names = users.map { user in
    format(user.name)
}
```

## 4. Stringly-typed APIs

Raw strings for identifiers, state, or configuration bypass the compiler's type checking:

```swift
// Bad — typos compile silently
func configure(mode: String) {
    if mode == "dark" { ... }
}

// Good — exhaustive, compiler-checked
enum Theme { case light, dark }
func configure(mode: Theme) {
    switch mode {
    case .light: ...
    case .dark: ...
    }
}
```

Also applies to: `Notification.Name`, dictionary keys, user defaults keys. Define typed constants.

## 5. God objects / massive types

Types that accumulate unrelated responsibilities (1000+ line view controllers, "Manager" classes doing everything):

- Fix: extract by responsibility into focused types.
- Use protocols and dependency injection to compose behavior.
- See `rules/swift-code-organization.md` for file structure guidelines.

## 6. Missing final on classes

Non-final classes use dynamic dispatch (slower) and can be subclassed unexpectedly:

```swift
// Bad — unintentional subclassability, vtable dispatch
class UserService {
    func fetchUser() { ... }
}

// Good — static dispatch, clear intent
final class UserService {
    func fetchUser() { ... }
}
```

Mark every class `final` unless inheritance is part of the documented design.

## 7. Blocking the main thread

Synchronous I/O, heavy computation, or `Thread.sleep` on the main queue freezes the UI:

```swift
// Bad — blocks main thread
let data = try Data(contentsOf: remoteURL)

// Good — async
let (data, _) = try await URLSession.shared.data(from: remoteURL)
```

**Cross-reference:** For async patterns and concurrency, see `swift-concurrency` skill.

## 8. Singleton abuse

Global singletons create hidden dependencies and make testing difficult:

```swift
// Bad — hidden dependency, hard to test
class ProfileView {
    func load() {
        let user = DataManager.shared.currentUser
    }
}

// Good — explicit dependency
class ProfileView {
    private let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
}
```

Singletons are acceptable for truly global, stateless resources (e.g., `URLSession.shared` for simple requests).

## 9. Ignoring compiler warnings

Warnings are potential bugs. Address them rather than silencing them.

- Use `#warning("TODO: ...")` for intentional work-in-progress markers.
- Never suppress a warning without understanding what it means.
- In Swift 6, many former warnings become errors — fix them early.

## 10. Overusing Any

Passing `Any` or `AnyObject` between layers throws away type safety:

```swift
// Bad — no compile-time checking
func process(_ items: [Any]) {
    for item in items {
        if let string = item as? String { ... }
        if let number = item as? Int { ... }
    }
}

// Good — constrained generic
func process<T: Processable>(_ items: [T]) {
    for item in items {
        item.process()
    }
}
```

See `rules/swift-protocols-generics.md` for `some` vs `any` guidance.

## 11. Not using Codable properly

Writing manual JSON parsing when `Codable` handles it:

```swift
// Bad — manual parsing
let name = json["user"]["name"] as? String ?? ""

// Good — type-safe decoding
struct User: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "user_name"
    }
}

let user = try JSONDecoder().decode(User.self, from: data)
```

Use `CodingKeys` for key mapping. Write custom `init(from:)` only when the JSON structure differs significantly from the model.
