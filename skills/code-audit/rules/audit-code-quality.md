# Audit Rules (Technology-Agnostic Code Quality)

## Purpose

Baseline quality checks that apply to any codebase regardless of technology stack. Use these when no technology-specific rule covers the issue.

## DRY violations

- **Identical duplication** (2+ files): flag and recommend extracting to a shared module.
- **Near-identical duplication** (same structure, different values): flag and recommend parameterizing.
- **Similar-but-divergent** (started the same, evolved differently): leave alone — forcing unification creates fragile abstractions.
- Threshold: flag when the duplicated block is ≥10 lines or appears in ≥3 locations.

## Over-engineering

Flag these patterns as `[WARNING]` with category `over-engineering`:
- Single-implementation abstractions (interface/abstract class with exactly one implementer and no plan for more).
- Passthrough wrappers that add no logic, validation, or transformation.
- Config-driven patterns with fewer than 3 variants (a simple `if`/`switch` is clearer).
- Premature optimization without evidence of a performance problem.
- Factory/builder/strategy patterns for types with only 1–2 concrete implementations.
- Generic type parameters that are always instantiated with the same type.

## Readability

Flag as `[SUGGESTION]` with category `readability`:
- Functions exceeding ~50 lines (suggest splitting by responsibility).
- Nesting depth exceeding 3 levels (suggest early returns, extraction, or guard clauses).
- Magic numbers or string literals used in logic (suggest named constants).
- Unclear or misleading names (variable name doesn't match its content or usage).
- Boolean parameters that obscure call-site intent (suggest options objects or separate functions).

## Performance

Flag as `[WARNING]` with category `performance`:
- Work inside loops that could be hoisted (invariant computations, repeated lookups).
- Unbounded data structures that grow without limit (missing pagination, caps, or eviction).
- Missing cleanup for timers, listeners, subscriptions, or connections.
- Synchronous blocking operations in async contexts (blocking I/O on main thread).
- Redundant data transformations (serializing then immediately deserializing, copying then discarding).

## Error handling

Flag with appropriate severity:
- **`[CRITICAL]`**: Swallowed errors with no logging or re-throw (silent failures).
- **`[WARNING]`**: Missing error boundaries at system edges (API handlers, event listeners, background jobs).
- **`[WARNING]`**: Generic error messages that lose context (catching specific error, throwing generic one).
- **`[SUGGESTION]`**: Inconsistent error handling patterns across similar modules.

## Security baseline

Flag as `[CRITICAL]` with category `security`:
- Hardcoded secrets, API keys, or credentials in source code.
- User input used directly in SQL, shell commands, or HTML without sanitization.
- Missing authentication or authorization checks on sensitive endpoints.
- Overly permissive CORS configuration.
- Sensitive data in logs, error messages, or client-side code.
