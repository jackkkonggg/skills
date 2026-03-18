# Code Audit (Agent Rules)

This is the fast-path playbook. Use it to make decisions quickly, then consult rule files for exact patterns and details.

## Non-negotiables

- Always detect technologies before evaluating code — never skip the detection phase.
- Always attempt Context7 doc loading for detected technologies before judging code.
- Never fabricate best-practice rules — every finding must trace to a loaded source or the generic code-quality rules.
- Always present the report before applying any fixes.
- Categorize every finding with severity and category tags.
- Installed skills take precedence over Context7 docs for the same technology.

## Workflow phases

### 1. Detect
Scan manifests, config files, and imports to identify every technology in scope.

### 2. Load Context
Resolve and load best-practice references: installed skills first, then Context7 docs, then generic quality rules. Note any gaps.

### 3. Evaluate
Walk the codebase from entry points outward. Check each module against loaded rules. Group findings by root cause. Assign severity and category.

### 4. Report
Present structured findings: preamble → summary → per-file findings → cross-cutting themes. Stop and wait for user direction.

### 5. Fix (optional)
Only when explicitly requested. Apply minimal targeted changes for approved severity levels. Re-check after fixing.

## Full references

- `rules/audit-detection.md`
- `rules/audit-context-loading.md`
- `rules/audit-evaluation.md`
- `rules/audit-code-quality.md`
- `rules/audit-reporting.md`
