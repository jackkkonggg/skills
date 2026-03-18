# Audit Rules (Reporting and Fix Strategy)

## Purpose

Structure audit output for clarity and actionability. Default to report-only; fix only when requested.

## Report structure

### 1. Preamble

Summarize what was detected and loaded:
- Detected technologies (from detection phase).
- Loaded sources: installed skills, Context7 docs, gaps.
- Audit scope: which directories/areas were audited.

### 2. Summary

Aggregate counts by severity and category:

```
| Severity     | Count |
|-------------|-------|
| CRITICAL    |     2 |
| WARNING     |     7 |
| SUGGESTION  |     4 |

| Category         | Count |
|-----------------|-------|
| security        |     2 |
| performance     |     3 |
| over-engineering|     2 |
| readability     |     4 |
| DRY             |     2 |
```

### 3. Findings by file

Group findings by file path, ordered by severity (critical first):

```
### `src/api/handler.ts`

1. **[CRITICAL] [security] SQL injection in user query** (line 42)
   Raw user input interpolated into SQL string. Use parameterized queries.

2. **[WARNING] [performance] N+1 query in list endpoint** (lines 55–70)
   Each item triggers a separate DB call. Batch with `WHERE id IN (...)`.
```

- Include the file path and line number(s) for each finding.
- Keep descriptions concise: what's wrong, why it matters, what to do.
- Include minimal diff snippets only when the fix is non-obvious.

### 4. Cross-cutting themes

After per-file findings, list patterns that appear across multiple files:
- Shared root causes (e.g. "no consistent error handling strategy").
- Systemic issues (e.g. "no input validation layer").
- Architectural observations (e.g. "business logic mixed into route handlers").

## Severity badges

Use these exact formats for consistency:
- `[CRITICAL]` — must fix before shipping.
- `[WARNING]` — should fix; degrades quality or reliability.
- `[SUGGESTION]` — consider fixing; improves maintainability.

## Default mode: report-only

- Present the full report and stop.
- Wait for user direction on which findings to address.
- Do not modify any code unless explicitly asked.

## "Audit and fix" mode

When the user requests `audit and fix` or similar:

1. Present the report first — do not skip reporting.
2. Ask which severity levels to auto-fix (default: critical only).
3. Apply minimal, targeted changes for approved findings.
4. After fixing, re-check the modified files to confirm the fix doesn't introduce new issues.
5. Summarize what was fixed and what remains.

## Presentation guidelines

- Lead with the most impactful findings.
- Keep the report scannable — use tables, badges, and consistent formatting.
- Avoid walls of text. If a finding needs extended explanation, link to the relevant doc or rule.
- For large audits, offer to break the report into sections the user can review incrementally.
