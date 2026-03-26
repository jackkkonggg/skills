# Swift Best Practices — Testing

## Canonical docs

- Apple: Swift Testing documentation
- WWDC 2024 "Meet Swift Testing"
- XCTest documentation (legacy)

## Swift Testing (preferred for new code)

Use the `@Test` macro to declare tests — no subclassing required, no `test` prefix needed:

```swift
import Testing

@Test("User login succeeds with valid credentials")
func loginSuccess() async throws {
    let service = AuthService()
    let result = try await service.login(user: "admin", password: "pass123")
    #expect(result.isAuthenticated)
    #expect(result.username == "admin")
}
```

### Assertions

- **`#expect`** — soft assertion. Records failure but continues the test:

```swift
#expect(count == 5)
#expect(name.hasPrefix("user_"))
#expect(throws: NetworkError.self) { try riskyOperation() }
```

- **`#require`** — hard assertion. Throws on failure, stopping the test:

```swift
let user = try #require(await fetchUser(id: 42))  // Stops if nil/throws
#expect(user.name == "Alice")
```

Use `#require` for preconditions that make subsequent assertions meaningless. Use `#expect` for everything else.

## Parameterized tests

Run the same test with multiple inputs using `@Test(arguments:)`:

```swift
@Test("Rejects blank input", arguments: ["", " ", "\t", "\n"])
func rejectsBlankInput(_ input: String) {
    #expect(throws: ValidationError.self) {
        try validate(input)
    }
}

@Test("Conversion roundtrips", arguments: [0, 1, -1, Int.max, Int.min])
func roundtrip(_ value: Int) {
    #expect(Int(String(value))! == value)
}
```

Parameterized tests replace multiple near-identical test functions. Each argument runs as an independent test case.

## Test organization with @Suite

Use `@Suite` to group related tests hierarchically:

```swift
@Suite("Authentication")
struct AuthenticationTests {
    @Test func validLogin() async throws { ... }
    @Test func invalidPassword() { ... }

    @Suite("Token Refresh")
    struct TokenRefreshTests {
        @Test func refreshExpiredToken() async throws { ... }
        @Test func refreshRevokedToken() { ... }
    }
}
```

Suites provide setup/teardown via `init` and `deinit` of the enclosing struct.

## Traits

Traits control test behavior:

```swift
@Test(.disabled("Server migration in progress"))
func syncWithServer() { ... }

@Test(.timeLimit(.minutes(1)))
func longRunningComputation() { ... }

@Test(.tags(.networking, .integration))
func endToEndFlow() async throws { ... }
```

Define custom tags for filtering:

```swift
extension Tag {
    @Tag static var networking: Self
    @Tag static var integration: Self
}
```

## XCTest compatibility

Continue using XCTest for:

- **UI tests** — `XCUITest` has no Swift Testing equivalent yet.
- **Performance tests** — `measure { }` is XCTest-only.
- **Objective-C test infrastructure** requirements.

XCTest and Swift Testing can coexist in the same test target.

**Do not mix frameworks in the same test function:**
- `XCTFail` inside a `@Test` function will NOT register as a failure.
- `#expect` inside an `XCTestCase` will NOT trigger a test failure.

## Test structure

Follow Arrange-Act-Assert:

```swift
@Test("Deposit increases balance")
func depositIncreasesBalance() {
    // Arrange
    var account = BankAccount(balance: 100)

    // Act
    account.deposit(50)

    // Assert
    #expect(account.balance == 150)
}
```

- One concept per test.
- Test names describe the expected behavior, not the method being tested.

## Test doubles

Use protocols for dependencies; inject test implementations:

```swift
protocol UserRepository {
    func fetch(id: Int) async throws -> User
}

// Production
final class APIUserRepository: UserRepository { ... }

// Test
struct StubUserRepository: UserRepository {
    var stubbedUser: User

    func fetch(id: Int) async throws -> User {
        stubbedUser
    }
}

@Test func displaysUserName() async throws {
    let stub = StubUserRepository(stubbedUser: User(name: "Alice"))
    let viewModel = UserViewModel(repository: stub)
    await viewModel.load()
    #expect(viewModel.displayName == "Alice")
}
```

Prefer hand-rolled stubs and fakes over heavyweight mocking frameworks.

## Cross-reference

- For testing async/concurrent code, see `swift-concurrency` skill, `references/testing.md`.
