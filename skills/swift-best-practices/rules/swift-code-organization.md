# Swift Best Practices — Code Organization

## Canonical docs

- Swift API Design Guidelines
- Apple Developer documentation

## File structure

- **One primary type per file.** Name the file after the type: `UserProfile.swift`.
- **Extensions with protocol conformance** in separate files: `UserProfile+Codable.swift`.
- **Group by feature**, not by type. Prefer `Features/Auth/LoginView.swift` over `Views/LoginView.swift`.

```
Sources/
  App/
    Features/
      Auth/
        LoginView.swift
        AuthService.swift
        AuthError.swift
      Profile/
        ProfileView.swift
        ProfileViewModel.swift
    Shared/
      Networking/
        APIClient.swift
        APIClient+Endpoints.swift
      Models/
        User.swift
```

## MARK comments

Use `// MARK: -` (with dash) for sections visible in Xcode's jump bar:

```swift
final class UserService {
    // MARK: - Properties

    private let client: APIClient
    private let cache: UserCache

    // MARK: - Initialization

    init(client: APIClient, cache: UserCache) {
        self.client = client
        self.cache = cache
    }

    // MARK: - Public API

    func fetchUser(id: Int) async throws -> User { ... }
    func updateUser(_ user: User) async throws { ... }

    // MARK: - Private Helpers

    private func validate(_ user: User) throws { ... }
}
```

Standard sections: Properties, Initialization, Public API, Private Helpers, Protocol Conformances.

## Extensions for protocol conformance

Separate protocol conformances into extensions for readability. One extension per protocol:

```swift
// UserProfile.swift
struct UserProfile {
    let name: String
    let email: String
    let joinDate: Date
}

// UserProfile+Codable.swift
extension UserProfile: Codable {}

// UserProfile+CustomStringConvertible.swift
extension UserProfile: CustomStringConvertible {
    var description: String { "\(name) <\(email)>" }
}
```

## Namespacing with enums

Use caseless enums as namespaces to group related constants or static functions. Prevents accidental instantiation:

```swift
enum API {
    enum Endpoints {
        static let users = "/api/v1/users"
        static let posts = "/api/v1/posts"
    }
    enum Headers {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
    }
}

enum Metrics {
    static let cornerRadius: CGFloat = 8
    static let padding: CGFloat = 16
}
```

## Access control

Default to the **most restrictive level** that works:

| Level | Scope |
|---|---|
| `private` | Enclosing declaration only |
| `fileprivate` | Enclosing file |
| `internal` | Enclosing module (default) |
| `public` | Any importing module (cannot subclass/override) |
| `open` | Any importing module (can subclass/override) |

```swift
public struct APIClient {
    public func fetchUsers() async throws -> [User] { ... }

    private func buildRequest(for endpoint: String) -> URLRequest { ... }
    private let session: URLSession
    private let baseURL: URL
}
```

- Mark implementation details `private`.
- Use `public` for API surfaces.
- Use `open` only when subclassing from external modules is intended.

## Import organization

Group imports and remove unused ones:

```swift
import Foundation          // System frameworks
import UIKit

import Alamofire           // Third-party
import KeychainAccess

import SharedModels        // Local modules
import Networking
```

## File length

Aim for **200-400 lines** per file as a soft ceiling. If a file exceeds this, look for extraction opportunities by responsibility. A file over 500 lines almost certainly has multiple concerns.

## Architecture

Do not mandate a specific architecture (MVC, MVVM, TCA, VIPER). Instead:

- **Separate business logic from UI** for testability.
- **Keep dependencies explicit** — prefer dependency injection over singletons.
- **Use protocols at module boundaries** for testability and flexibility.
- Match the architecture to the project's complexity — MVVM for most SwiftUI apps, TCA for complex state management.
