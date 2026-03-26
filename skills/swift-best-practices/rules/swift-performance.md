# Swift Best Practices — Performance

## Canonical docs

- Apple: Writing High-Performance Swift Code
- WWDC 2016 "Understanding Swift Performance"
- https://github.com/swiftlang/swift/blob/main/docs/OptimizationTips.rst

## Profile first

Premature optimization is counterproductive. Use **Instruments** to identify actual bottlenecks before optimizing. The guidelines below are for informed decisions, not blanket application.

## final keyword

Mark classes `final` unless explicitly designed for subclassing. `final` enables **static dispatch** — the compiler resolves method calls at compile time instead of using vtable lookup:

```swift
final class NetworkManager {
    func fetchData() { ... }  // Direct call, no vtable dispatch
}
```

Every class without `final` pays a vtable dispatch cost and can be subclassed unexpectedly.

## Access control for optimization

Use the **most restrictive access level** possible: `private` > `fileprivate` > `internal` > `public`.

- The compiler can infer `final` for `private` and `fileprivate` declarations.
- With **Whole Module Optimization** (`-whole-module-optimization`), `internal` declarations can also be devirtualized.
- `public` prevents cross-module optimization unless marked `@inlinable`.

## Whole Module Optimization (WMO)

Enable `-whole-module-optimization` in release builds. This lets the compiler analyze the entire module as a single unit, enabling:

- Cross-file inlining
- Devirtualization of internal methods
- Dead-code elimination

Trade-off: longer compile times in debug; use only for release.

## Copy-on-write

Standard collections (`Array`, `Dictionary`, `Set`) use COW: memory is shared until mutation. Only then is a copy made.

```swift
// Good: mutates in place (no copy if uniquely referenced)
func append(to array: inout [Int], value: Int) {
    array.append(value)
}

// Wasteful: forces a copy
func appending(to array: [Int], value: Int) -> [Int] {
    var copy = array  // Triggers copy on next mutation
    copy.append(value)
    return copy
}
```

Use `reserveCapacity(_:)` when the final collection size is known:

```swift
var results: [ProcessedItem] = []
results.reserveCapacity(items.count)
for item in items {
    results.append(process(item))
}
```

## lazy properties

Use `lazy var` for expensive initialization that may not be needed:

```swift
final class DataProcessor {
    lazy var expensiveResult: [ProcessedItem] = {
        performExpensiveComputation()
    }()
}
```

Caveats:
- Requires `var` (not `let`).
- Not thread-safe — use synchronization if accessed from multiple threads.
- On structs, accessing `lazy var` mutates the struct (requires `var` binding).

## ContiguousArray

Use `ContiguousArray` instead of `Array` when the element is a value type and NSArray bridging is not needed. Guarantees contiguous storage for better cache performance in numerical code:

```swift
var buffer: ContiguousArray<Float> = []
buffer.reserveCapacity(1024)
```

## @inlinable

Mark performance-critical public functions `@inlinable` to allow cross-module inlining:

```swift
@inlinable
public func clamp<T: Comparable>(_ value: T, to range: ClosedRange<T>) -> T {
    min(max(value, range.lowerBound), range.upperBound)
}
```

Trade-off: the function body becomes part of the module's ABI. Use sparingly for stable, small functions.

## Avoid unnecessary allocations

- Prefer **stack allocation** (value types) over **heap allocation** (classes) in hot paths.
- Use `withUnsafeBufferPointer` for performance-critical array operations that avoid bounds checking.
- Use wrapping arithmetic (`&+`, `&-`, `&*`) when you can prove overflow will not occur, to skip overflow checks.

## Compiler optimization flags

| Flag | Purpose | When |
|---|---|---|
| `-Onone` | No optimization | Debug builds |
| `-O` | Optimize for speed | Release builds (default) |
| `-Osize` | Optimize for binary size | Size-constrained targets |

## Cross-reference

- For concurrency performance (actor hops, suspension points), see `swift-concurrency` skill, `references/performance.md`.
- For SwiftUI performance (view diffing, state invalidation), see `swiftui-expert-skill`.
- For value types vs reference types, see `rules/swift-value-vs-reference-types.md`.
