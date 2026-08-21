---
name: thermo-nuclear-code-quality-tests
description: Use to audit, prune, rewrite, or add tests so suites protect durable contracts without preserving deleted behavior or coverage theater.
---

# Thermo-Nuclear Code Quality Tests

Keep tests whose confidence earns maintenance. Protect durable contracts and
meaningful risks, not implementation history.

## Required route

1. Read [references/test-quality-playbook.md](references/test-quality-playbook.md)
   before editing tests.
2. Bound the audit and classify affected behavior as retained, new, explicitly
   deleted, or unknown. Explicit user/product decisions authorize deletion;
   missing coverage or low usage is not deletion authority.
3. For retained and new contracts, choose the cheapest test surface that proves
   the observable outcome. Use `tdd` for a new contract or bug regression with a
   cheap failing-first path.
4. For explicitly deleted behavior, remove tests, fixtures, snapshots, mocks,
   helpers, and harness branches that exist only for it. Do not reproduce the
   retired behavior. Test absence only when absence is itself a durable contract.
5. Require mutation sensitivity proof for every new test, materially rewritten
   test, and questionable retained test. Do not re-prove clearly valuable,
   unchanged tests merely for ceremony.
6. Treat coverage as a diagnostic, not a quality target. Never add filler tests
   or silently change a threshold to preserve a percentage.
7. Run the focused tests and proportional broader validation. Report the
   contract ledger, tests kept/removed/changed, sensitivity evidence, commands
   with exit status, and unresolved policy conflicts.

Pause when behavior ownership is unknown or an enforced coverage gate conflicts
with authorized pruning and changing that policy was not authorized.
