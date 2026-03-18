# Audit Rules (Context Loading)

## Purpose

Load best-practice references for each detected technology before evaluation begins. This phase ensures findings are grounded in real documentation, not fabricated rules.

## Context7 MCP two-step flow

For each detected technology (prioritized by centrality):

1. **Resolve**: call `resolve-library-id` with the technology name to find the matching library.
2. **Query**: call `query-docs` with the resolved library ID and a topic relevant to audit (e.g. "best practices", "common mistakes", "performance", "security").

### Prioritization

Load context in this order to maximize value within the context budget:

1. **Primary framework** (e.g. Next.js, Django, Rails) — highest impact on architecture.
2. **Data layer** (e.g. Prisma, Convex, SQLAlchemy) — correctness-critical.
3. **Major libraries** (e.g. React, Vue, Express) — high surface area.
4. **Utilities and tooling** (e.g. lodash, zod, ESLint) — load only if audit scope includes them.

### Context budget

- Limit Context7 queries to the top 5–8 technologies to avoid overwhelming the context window.
- For each query, request focused topics rather than full API references.

## Installed skill discovery

- Scan sibling skill directories (`skills/*/SKILL.md`) for skills whose `name` or `description` matches a detected technology.
- When a matching installed skill is found, load its rules per its own loading order.
- Installed skills provide curated, opinionated rules — they take precedence over general Context7 docs for the same technology.

## Precedence rules

1. **Installed skills** — curated for the user's workflow; highest trust.
2. **Context7 docs** — up-to-date general documentation; good coverage.
3. **Generic code-quality rules** (`rules/audit-code-quality.md`) — technology-agnostic fallback.

## Graceful degradation

- If Context7 MCP is unavailable or a `resolve-library-id` call returns no match:
  - Fall back to installed skills and generic quality rules.
  - Note the gap in the report preamble so the user knows which technologies lacked reference docs.
- If no installed skill and no Context7 match exists for a technology, audit it using only the generic code-quality rules and flag the gap.

## Output

After loading, summarize what was loaded:

```
## Loaded Context

### Installed Skills
- convex-best-practices (8 rule files)
- gsap-best-practices (4 rule files)

### Context7 Docs
- next.js (best practices, performance)
- prisma (query optimization, schema design)

### Gaps (no reference found)
- custom-internal-lib
```
