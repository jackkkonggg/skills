# Swift Best Practices — API Design & Naming

## Canonical docs

- https://www.swift.org/documentation/api-design-guidelines/
- The Swift Programming Language — Naming section

## Clarity at the call site

The single most important goal is **clarity at the point of use**. APIs are declared once but used many times — optimize for the reader at the call site.

- **Clarity over brevity.** Swift already reduces boilerplate via type inference; never sacrifice readability for shorter code.
- **Omit needless words** that merely repeat type information already available from context.

```swift
// Bad — "Element" repeats the type
func removeElement(_ member: Element) -> Element?

// Good — clear and concise
func remove(_ member: Element) -> Element?
```

- **Include all words necessary to avoid ambiguity.**

```swift
// Bad — ambiguous: remove the element, or remove at index?
employees.remove(x)

// Good — unambiguous
employees.remove(at: position)
```

## Name by role, not type

Name variables, parameters, and associated types by their **role**, not their type:

```swift
// Bad
var string = "Hello"
func add(_ constraint: NSLayoutConstraint)

// Good
var greeting = "Hello"
func add(_ observer: NSLayoutConstraint)
```

When type information is weak (e.g., `Any`, `AnyObject`), compensate with descriptive names:

```swift
func addObserver(_ observer: Any, forKeyPath path: String)
```

## Argument labels

- **Omit the first label** when the argument forms a grammatical phrase with the method name: `x.addSubview(y)`.
- **Omit the first label** for value-preserving type conversions: `Int64(someUInt32)`.
- **Use descriptive labels** for narrowing conversions: `UInt32(truncating: source)`.
- **When the first argument is a prepositional phrase, label at the preposition:** `removeBoxes(havingLength: 12)`.
- **Label all other arguments** for clarity.
- **Omit all labels** when arguments cannot be meaningfully distinguished: `min(number1, number2)`.

```swift
// Good — reads naturally: "insert y at z"
x.insert(y, at: z)
x.subViews(havingColor: y)
x.capitalizingNouns()

// Bad — awkward to read
x.insert(y, position: z)
x.subViews(color: y)
x.capitalizeNouns()
```

## Naming conventions

- **Types and protocols:** `UpperCamelCase` — `UserProfile`, `Equatable`.
- **Everything else:** `lowerCamelCase` — `fetchData()`, `userName`, `case loading`.
- **Acronyms** uniformly up- or down-cased per position: `utf8Bytes`, `HTTPSConnection`, `isRepresentableAsASCII`.
- **Booleans** read as assertions: `isEmpty`, `canBecomeFirstResponder`, `hasUnsavedChanges`.
- **Protocols describing capabilities:** `-able`, `-ible`, `-ing` suffix — `Equatable`, `Hashable`, `ProgressReporting`.
- **Protocols describing what something is:** nouns — `Collection`, `Sequence`, `WidgetFactory`.

## Mutating / nonmutating pairs

| Mutating (verb) | Nonmutating (noun / -ed / -ing) |
|---|---|
| `x.sort()` | `z = x.sorted()` |
| `x.reverse()` | `z = x.reversed()` |
| `x.append(y)` | `z = x.appending(y)` |
| `y.formUnion(z)` | `x = y.union(z)` |

- Methods **with side effects** use imperative verbs: `sort()`, `append(_:)`.
- Methods **without side effects** return new values using `-ed` / `-ing`: `sorted()`, `appending(_:)`.

## Factory methods

Factory methods that return new instances begin with `make`:

```swift
func makeIterator() -> IndexingIterator<Self>
func makeBody(configuration: Configuration) -> some View
```

## Documentation comments

- Use `///` format for all public API documentation. Never use `/** */`.
- Write doc comments for **every public declaration**. If you struggle to describe an API simply, reconsider the design.
- Include `- Parameter`, `- Returns`, and `- Throws` tags for functions.
