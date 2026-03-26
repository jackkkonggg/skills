# Swift Best Practices — Error Handling

## Canonical docs

- The Swift Programming Language — Error Handling
- SE-0413: Typed throws

## Domain-specific error enums

Model errors as enums conforming to `Error`. Include associated values for context:

```swift
enum NetworkError: Error {
    case invalidURL
    case timeout(duration: TimeInterval)
    case httpError(statusCode: Int)
    case decodingFailed(underlying: Error)
}
```

Keep error types focused on one domain. A `NetworkError` should not include database errors.

## do-catch

Catch **specific** errors before the generic `catch`. Never use an empty `catch {}`.

```swift
do {
    let data = try fetchData(from: url)
    let model = try JSONDecoder().decode(Model.self, from: data)
    display(model)
} catch let error as NetworkError {
    handleNetworkError(error)
} catch let error as DecodingError {
    handleDecodingError(error)
} catch {
    handleUnexpectedError(error)
}
```

Every `catch` block must do one of:
- Log the error
- Re-throw the error
- Wrap and return a typed failure
- Present the error to the user

## Typed throws (Swift 6+)

Use `throws(MyError)` to declare the exact error type a function can throw. This enables exhaustive `catch` and eliminates the need for `as` casts:

```swift
enum FileError: Error {
    case notFound
    case permissionDenied
    case corrupted
}

func load(from path: String) throws(FileError) -> Data {
    guard FileManager.default.fileExists(atPath: path) else {
        throw .notFound
    }
    // ...
}

do throws(FileError) {
    let data = try load(from: "/tmp/config.json")
} catch .notFound {
    // Compiler ensures exhaustive handling
} catch .permissionDenied {
    // ...
} catch .corrupted {
    // ...
}
```

**Untyped `throws` remains the better default** for most code. Use typed throws only when callers genuinely benefit from knowing the exact error type.

## Guard + throw for preconditions

Validate inputs early. Fail fast — don't let invalid state propagate:

```swift
func updateUser(_ user: User) throws {
    guard !user.name.isEmpty else {
        throw ValidationError.emptyName
    }
    guard user.age > 0 else {
        throw ValidationError.invalidAge(user.age)
    }
    // proceed with valid data
}
```

## Result type

Use `Result<Success, Failure>` when you need to store or pass around a success-or-failure value, especially in callback-based APIs:

```swift
func fetchUser(id: Int, completion: @escaping (Result<User, NetworkError>) -> Void) {
    // ...
}
```

For synchronous code, prefer `do-catch` over `Result`. For async code, prefer `async throws`.

## try? and try!

- **`try?`** — Use when you genuinely want to discard the error and get `nil`. Appropriate when the error adds no information:

```swift
let cachedImage = try? loadFromCache(key)
```

- **`try!`** — Must not be used outside of tests or documented invariants where failure is a programmer error.

## LocalizedError for user-facing messages

Conform to `LocalizedError` when errors will be displayed to users:

```swift
enum AppError: LocalizedError {
    case networkUnavailable
    case dataCorrupted

    var errorDescription: String? {
        switch self {
        case .networkUnavailable: "No internet connection. Please try again."
        case .dataCorrupted: "The data could not be read. Please contact support."
        }
    }
}
```

## Cross-reference

- For async error handling and `CancellationError`, see `swift-concurrency` skill.
