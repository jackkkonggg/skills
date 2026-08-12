---
name: thermo-nuclear-code-quality-review
description: Run a strict maintainability review for abstractions, file growth, and branching; use for thermonuclear, deep, or harsh audits.
---

# Thermo-Nuclear Code Quality Review

Conduct an unusually demanding, evidence-based maintainability review. Review
the requested change only; do not implement fixes unless asked.

## Procedure

1. Establish the review scope: diff, changed-file contents, relevant callers,
   existing abstractions, and file sizes before and after the change.
2. Read the complete [upstream rubric](references/upstream-rubric.md).
3. Look for a code-judo move that deletes complexity rather than moving it.
   Trace module boundaries when the diff crosses one.
4. Make high-conviction, actionable findings only. Do not turn this into a
   cosmetic style review or invent concerns not supported by the evidence.

## Response

List findings in the rubric's priority order. For each, identify the location,
the structural consequence, and a concrete cleaner shape. State explicitly when
no blocking maintainability issue is evident; do not approve merely because the
behavior appears correct.
