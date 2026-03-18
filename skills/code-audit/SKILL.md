---
name: code-audit
description: Use when auditing a codebase against best practices. Auto-detects technologies, loads relevant docs via Context7 MCP and installed skills, evaluates code systematically, and produces a prioritized findings report with optional auto-fix.
---

# Code Audit

Structured codebase audit with automatic technology detection, context loading, and prioritized reporting.

## Rule loading order

1. Read `rules/audit-detection.md`.
2. Read `rules/audit-context-loading.md`.
3. Read `rules/audit-evaluation.md`.
4. Read `rules/audit-code-quality.md`.
5. Read `rules/audit-reporting.md`.
6. Use `AGENTS.md` as a compact summary plus pointer.

## Enforcement policy

- Use strict language (`must` / `must not`) for workflow sequence: always detect before evaluate, always load context before judging.
- Use recommendation-first language for code quality findings.
- Installed skills take precedence over Context7 docs when both cover the same technology.
- Never fabricate best-practice rules — every finding must trace to a loaded source or the generic code-quality rules in `rules/audit-code-quality.md`.
