# Swift Best Practices — Swift Package Manager

## Canonical docs

- Apple: Swift Package Manager documentation
- https://www.swift.org/documentation/package-manager/

## Package.swift structure

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyLibrary",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "MyLibrary", targets: ["MyLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "MyLibrary",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]
        ),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: ["MyLibrary"]
        ),
    ]
)
```

- Set `swift-tools-version` to the minimum Swift version you support.
- Declare `platforms` explicitly — don't rely on defaults.
- Use `.product(name:package:)` to import specific products from dependencies.

## Versioning and dependencies

Use **semantic versioning** for all packages:

```swift
// Good — accept compatible versions (1.2.0 to next major)
.package(url: "https://github.com/example/lib.git", from: "1.2.0")

// Good — accept within minor version range
.package(url: "https://github.com/example/lib.git", "1.2.0"..<"1.3.0")

// Avoid in production — tracks a moving target
.package(url: "https://github.com/example/lib.git", branch: "main")

// Avoid in production — fragile, no update path
.package(url: "https://github.com/example/lib.git", revision: "abc123")
```

- **Applications:** commit `Package.resolved` for reproducible builds.
- **Libraries:** do not commit `Package.resolved` — let consumers resolve versions.

## Target separation

Keep targets focused on one concern:

```swift
targets: [
    .target(name: "Core"),              // Business logic
    .target(name: "Networking", dependencies: ["Core"]),
    .target(name: "UI", dependencies: ["Core"]),
    .testTarget(name: "CoreTests", dependencies: ["Core"]),
    .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
]
```

This enables parallel builds and enforces module boundaries.

## Local packages for modular apps

Extract features into local packages for build parallelism and clear access control:

```swift
// In the app's Package.swift or project settings
.package(path: "../Packages/FeatureAuth"),
.package(path: "../Packages/SharedUI"),
```

Benefits: faster incremental builds, enforced `public`/`internal` boundaries, independent testability.

## Package plugins

**Build tool plugins** run code generation at build time:

```swift
.plugin(name: "SwiftLintPlugin", capability: .buildTool())
```

**Command plugins** provide custom swift package commands:

```swift
// Usage: swift package format
.plugin(name: "FormatPlugin", capability: .command(
    intent: .sourceCodeFormatting(),
    permissions: [.writeToPackageDirectory(reason: "Format source files")]
))
```

## Dependency hygiene

- Audit transitive dependencies periodically — each adds build time and attack surface.
- Prefer packages with minimal transitive dependencies.
- Prefer SwiftPM over CocoaPods/Carthage for new projects — it is Apple's official tool with first-class Xcode integration.
- Update dependencies regularly for security patches.
