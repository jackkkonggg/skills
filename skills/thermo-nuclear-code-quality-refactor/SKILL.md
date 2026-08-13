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

1. Read [references/refactor-playbook.md](references/refactor-playbook.md) before
   planning or editing.
2. For a rewrite, subsystem replacement, data migration, or staged cutover, also
   read [references/rewrite-playbook.md](references/rewrite-playbook.md).
3. Before designing, inventory behavior and present specific features, edge
   cases, or guarantees that could be removed. Ask which may be descoped; if
   none, confirm strict behavior parity. Do not infer permission from missing
   tests or low usage.
4. Ask separately whether clients/data must be migrated and whether
   old APIs, contracts, events, formats, CLI, or configuration must stay
   backward compatible. If yes, record surfaces, support period, and
   retirement criteria. If no, delete legacy paths rather than recreating them.
5. Choose refactor, incremental replacement, or rewrite from evidence. State the
   target architecture, preserved contract, accepted removals, relevant
   performance budgets or a not-applicable finding, migration path, rollback,
   and deletion end-state.
6. Execute in small verified slices. Keep the system working between slices and
   remove superseded code as soon as its callers are migrated.
7. Finish with direct behavior evidence, relevant performance evidence, and a
   read-only `thermo-nuclear-code-quality-review` pass.

Pause when descoping, compatibility, migration, or rollout needs a product
decision the user has not authorized.
