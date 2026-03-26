# Swift Best Practices (Agent Rules)

This is the fast-path playbook. Use it to make decisions quickly, then consult the rule files for exact patterns and examples.

## Non-negotiables

- Never force-unwrap (`!`) outside of tests, IBOutlets, or `fatalError`-documented preconditions; use `guard let`, `if let`, or nil-coalescing.
- Never ignore errors silently; every `catch` must log, re-throw, wrap, or return a typed failure.
- Mark classes `final` unless explicitly designed for inheritance; prefer structs for data models.
- Use `[weak self]` in escaping closures that capture `self` on reference types to prevent retain cycles; use `[unowned self]` only with a documented lifetime guarantee.
- Follow Swift API Design Guidelines: name methods as grammatical English phrases, label all arguments for clarity at the call site, use mutating/nonmutating naming pairs.
- Add `///` documentation comments on all public API symbols (types, functions, properties that cross module boundaries).
- Use `some` (opaque types) by default; switch to `any` (existential) only when runtime type erasure or heterogeneous collections are required.

## Core defaults

- Prefer value types (structs, enums) over reference types (classes) unless identity or inheritance is needed.
- Use `guard` for early exits; keep the happy path unindented.
- Model domain errors as `enum` types conforming to `Error`; use typed throws (`throws(MyError)`) in Swift 6+ when callers benefit from knowing the exact error type.
- Limit function parameters to 3 or fewer; group related parameters into a configuration struct or use default values.
- Prefer protocol extensions for shared default implementations over base classes.
- Use `lazy var` for expensive properties that may not be accessed.
- Mark properties and collections `let` by default; use `var` only when mutation is required.
- Write new tests using Swift Testing (`@Test`, `#expect`); use XCTest only for UI tests, performance tests, or legacy compatibility.
- Organize code with `// MARK: -` sections and extensions by protocol conformance.
- Use Swift Package Manager for dependency management; pin versions with semantic version ranges.

## Scope boundaries

- **Concurrency** (async/await, actors, Sendable, tasks) — defer to `swift-concurrency` skill.
- **SwiftUI** (views, state management, layout, animations) — defer to `swiftui-expert-skill` skill.

## Full references

- `rules/swift-api-design-naming.md`
- `rules/swift-value-vs-reference-types.md`
- `rules/swift-optionals.md`
- `rules/swift-error-handling.md`
- `rules/swift-protocols-generics.md`
- `rules/swift-property-wrappers-result-builders.md`
- `rules/swift-memory-management.md`
- `rules/swift-performance.md`
- `rules/swift-modern-features.md`
- `rules/swift-testing.md`
- `rules/swift-package-manager.md`
- `rules/swift-code-organization.md`
- `rules/swift-common-pitfalls.md`
