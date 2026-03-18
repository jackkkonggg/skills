# Audit Rules (Evaluation Framework)

## Purpose

Systematically evaluate the codebase against loaded best practices and quality rules. Focus on root causes, not symptoms.

## Systematic walk

- Start from entry points: `main`, `index`, `app`, route handlers, exported API surfaces.
- Follow the dependency graph outward: entry → routes/handlers → services/logic → data layer → utilities.
- For each module, check against the loaded rules for its technology stack.

## Severity levels

### `[CRITICAL]`
Issues that affect correctness, security, or cause resource leaks:
- Logic errors, race conditions, data corruption risks
- Security vulnerabilities (injection, auth bypass, secrets in code, SSRF)
- Resource leaks (unclosed connections, missing cleanup, unbounded growth)
- Breaking API contracts or data loss scenarios

### `[WARNING]`
Issues that degrade quality but don't cause immediate failures:
- Performance anti-patterns (N+1 queries, unnecessary re-renders, missing indexes)
- Accessibility violations
- Deprecated API usage
- Missing error boundaries or error handling at system boundaries
- Inconsistent patterns that make the codebase harder to maintain

### `[SUGGESTION]`
Opportunities for improvement:
- Readability improvements
- Minor DRY violations
- Naming clarity
- Code organization

## Categories

Tag every finding with one or more categories:
- **correctness** — wrong behavior, logic errors, contract violations
- **security** — vulnerabilities, secrets exposure, auth issues
- **performance** — unnecessary work, missing optimization, scaling concerns
- **readability** — unclear code, excessive complexity, poor naming
- **DRY** — duplication that increases maintenance burden
- **over-engineering** — unnecessary abstraction, premature generalization
- **accessibility** — missing or broken a11y patterns

## Root cause focus

- When multiple findings share a root cause, group them under one finding with the shared cause as the title.
- Example: if 5 components each have an unclosed subscription, the finding is "Missing subscription cleanup pattern" with the 5 instances listed, not 5 separate findings.
- Explain WHY the code is problematic, not just WHAT is wrong. Include the consequence of not fixing it.

## Scope control

- Audit only user-specified areas. If the user says "audit the API layer", do not audit the frontend.
- For full-codebase audits on large projects (>50 files), propose an audit plan first:
  - List the areas to audit in priority order.
  - Estimate effort per area.
  - Ask the user to confirm or adjust before proceeding.
- Always skip generated code, vendored dependencies, lock files, and build output.
- Skip test files unless the user explicitly asks to audit tests.
