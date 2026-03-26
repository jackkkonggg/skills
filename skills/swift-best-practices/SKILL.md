---
name: swift-best-practices
description: Use when writing, reviewing, or refactoring Swift code to enforce best practices — naming, types, error handling, protocols, memory management, performance, and modern patterns — for idiomatic, safe Swift.
---

# Swift Best Practices

Apply official Swift API Design Guidelines and community best practices when writing,
reviewing, or auditing Swift codebases.

## Scope boundaries

This skill covers **core Swift language** fundamentals. It does not cover:

- **Concurrency** (async/await, actors, Sendable, tasks) — use `swift-concurrency`.
- **SwiftUI** (views, state management, layout, animations) — use `swiftui-expert-skill`.

When a topic touches a boundary (e.g., memory management in tasks, testing async code),
defer to the specialized skill and cross-reference it.

## Rule loading order

1. Read `rules/swift-api-design-naming.md`.
2. Read `rules/swift-value-vs-reference-types.md`.
3. Read `rules/swift-optionals.md`.
4. Read `rules/swift-error-handling.md`.
5. Read `rules/swift-protocols-generics.md`.
6. Read `rules/swift-property-wrappers-result-builders.md`.
7. Read `rules/swift-memory-management.md`.
8. Read `rules/swift-performance.md`.
9. Read `rules/swift-modern-features.md`.
10. Read `rules/swift-testing.md`.
11. Read `rules/swift-package-manager.md`.
12. Read `rules/swift-code-organization.md`.
13. Read `rules/swift-common-pitfalls.md`.
14. Use `AGENTS.md` as a compact summary plus pointer.

## Enforcement policy

- Use recommendation-first language for style, naming, and organizational guidance.
- Use strict language (`must` / `must not`) only for memory safety, type safety, or runtime failure prevention.
- Prefer the official Swift API Design Guidelines (swift.org/documentation/api-design-guidelines) and The Swift Programming Language book when resolving conflicts; update these rules when best practices evolve.
- For concurrency topics, defer to `swift-concurrency`. For SwiftUI topics, defer to `swiftui-expert-skill`.
