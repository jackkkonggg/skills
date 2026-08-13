---
name: thermo-nuclear-code-quality-refactor
description: Use for ambitious refactors or rewrites where architecture, code cleanliness, scope, and measured performance must improve together.
---

# Thermo-Nuclear Code Quality Refactor

Build the smallest coherent design that satisfies an explicitly agreed product
contract and measured operational constraints. Treat a refactor as
behavior-preserving; treat a rewrite as permission to reconsider implementation,
not as permission to change behavior.

## Required route

1. Read [references/refactor-playbook.md](references/refactor-playbook.md) and
   [references/decision-gates.md](references/decision-gates.md) before planning
   or editing.
2. For a rewrite, subsystem replacement, data migration, or staged cutover, also
   read [references/rewrite-playbook.md](references/rewrite-playbook.md).
3. Ground the real contract. Run every mandatory gate and each triggered
   conditional gate. Batch unresolved user questions, reuse prior answers, and
   record pass evidence. Do not infer product authority from missing tests or
   low usage.
4. Choose refactor, incremental replacement, or rewrite from evidence. State the
   target architecture, preserved contract, accepted removals, relevant
   performance budgets or a not-applicable finding, migration path, rollback,
   and deletion end-state.
5. Execute in small verified slices. Keep the system working between slices and
   remove superseded code as soon as its callers are migrated.
6. Finish with direct behavior evidence, relevant performance evidence or a
   not-applicable finding, satisfied gate states, and a read-only
   `thermo-nuclear-code-quality-review` pass.

Pause only when a blocking gate needs a decision the user has not authorized.
