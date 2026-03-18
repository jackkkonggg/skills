# Audit Rules (Technology Detection)

## Purpose

Identify every technology in the target codebase before any evaluation begins. Detection output feeds the context-loading phase.

## Manifest scanning

- Read dependency manifests at the project root and common subdirectories:
  - **JS/TS**: `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
  - **Python**: `requirements.txt`, `pyproject.toml`, `setup.py`, `Pipfile`
  - **Rust**: `Cargo.toml`
  - **Go**: `go.mod`
  - **Ruby**: `Gemfile`
  - **Java/Kotlin**: `build.gradle`, `pom.xml`
  - **PHP**: `composer.json`
  - **.NET**: `*.csproj`, `*.fsproj`
- Extract dependency names and version constraints from each manifest.

## Config scanning

- Detect frameworks and tools by the presence of their config files:
  - **Next.js**: `next.config.*`
  - **Vite**: `vite.config.*`
  - **Webpack**: `webpack.config.*`
  - **TypeScript**: `tsconfig.json`, `tsconfig.*.json`
  - **Tailwind**: `tailwind.config.*`
  - **Prisma**: `prisma/schema.prisma`
  - **Convex**: `convex/` directory
  - **Docker**: `Dockerfile`, `docker-compose.yml`
  - **ESLint**: `.eslintrc.*`, `eslint.config.*`
  - **Prettier**: `.prettierrc*`, `prettier.config.*`
  - **Vitest**: `vitest.config.*`
  - **Jest**: `jest.config.*`
- Note the presence and version (when available) of each detected tool.

## Import scanning

- When a manifest lists a dependency but confidence is low (e.g. transitive dep, workspace root), confirm actual usage by grepping entry points and source files for import/require statements.
- For monorepos, detect per-package technologies separately and note shared root dependencies.

## Output format

Produce a structured detection summary grouped by category:

```
## Detected Technologies

### Frameworks
- { technology, version, confidence: high|medium|low, source: manifest|config|import }

### Libraries
- ...

### Build Tools
- ...

### Testing
- ...

### Infrastructure
- ...
```

## Scope

- Scan the user-specified directory. Default to the project root.
- Skip `node_modules/`, `vendor/`, `dist/`, `build/`, `.git/`, and other generated directories.
- For monorepos, list the top-level detection first, then per-package details.
