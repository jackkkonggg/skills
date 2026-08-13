# Rewrite and Replacement Playbook

Read this in addition to the refactor playbook for rewrites, subsystem
replacements, data migrations, and staged cutovers.

## Contents

- [Make the rewrite earn its cost](#make-the-rewrite-earn-its-cost)
- [Negotiate parity before design](#negotiate-parity-before-design)
- [Choose a compatibility mode](#choose-a-compatibility-mode)
- [Find a safe seam](#find-a-safe-seam)
- [Design transition and target separately](#design-transition-and-target-separately)
- [Prove behavior before cutover](#prove-behavior-before-cutover)
- [Roll out and retire](#roll-out-and-retire)
- [Rewrite rejection criteria](#rewrite-rejection-criteria)

## Make the rewrite earn its cost

Start with a rebuttable presumption against a big-bang rewrite. Require concrete
evidence that a bounded rewrite or incremental replacement is better than
refactoring in place.

Good evidence includes:

- the current ownership or dependency structure cannot support required change
  without repeated cross-cutting edits;
- an obsolete platform, runtime, data model, or deployment constraint blocks a
  required outcome;
- characterization reveals a much smaller stable contract than the current
  implementation;
- the replacement can be isolated behind a seam and verified against a reliable
  oracle;
- the migration can deliver value in slices and has a credible rollback;
- the user has explicitly authorized contract changes and feature removals.

“The code is ugly,” “a new stack is nicer,” and “rewriting will be faster” are
not sufficient evidence.

## Negotiate parity before design

Full feature parity is a product choice, not a default engineering requirement.
Inventory features, reports, integrations, compatibility versions, data
histories, error behaviors, operational tools, and edge cases. Present removal
or narrowing candidates through the mandatory descoping checkpoint.

For every retained capability, define an observable acceptance condition. For
every removal, record who authorized it, affected users or data, communication
needs, and whether migration or export is required.

Do not let “parity” mean reproducing accidental implementation details. Preserve
observable contracts and necessary operational behavior; redesign internals.

## Choose a compatibility mode

Decide compatibility before designing the transition. Do not default to keeping
every old surface, and do not assume a rewrite authorizes breaking it. Choose
and document one mode for each contract:

1. **Retain** — old consumers continue indefinitely; make the supported contract
   explicit and test it.
2. **Bridge temporarily** — adapt the old boundary to one canonical new model;
   define migration owner, telemetry, support deadline, and deletion criteria.
3. **Break and migrate** — update or communicate with every known consumer,
   transform or export required data, then remove the old surface at cutover.
4. **Remove without migration** — use only with explicit authorization for both
   the contract and affected data; delete the compatibility machinery entirely.

Choose API compatibility, client migration, and persisted-data migration
independently. Prefer a clean breaking cutover when the user confirms no legacy
support is required and the blast radius is controlled. Prefer a narrow,
expiring boundary adapter when compatibility is required; never reproduce old
version branching throughout the target architecture.

## Find a safe seam

Prefer a bounded replacement behind an existing or deliberately introduced
seam:

- API, command, queue, event, repository, data-access, UI route, or module
  boundary;
- caller adapter that supports old and new implementations temporarily;
- traffic, tenant, feature, dataset, or operation slice that can move alone;
- source-of-truth boundary that avoids copying derived legacy state.

If no seam exists, make the first slice a behavior-preserving preparatory
refactor that creates one. Do not introduce a permanent generic abstraction
solely to host a temporary migration.

## Design transition and target separately

Specify both architectures:

**Target architecture**

- final ownership, interfaces, data model, runtime, dependencies, invariants,
  performance budgets, and deletion state;
- no migration-only adapters, dual writes, shadow reads, toggles, or legacy
  naming unless they have enduring product value.

**Transitional architecture**

- traffic routing, translation, synchronization, backfill, shadowing, feature
  flags, compatibility, observability, and rollback needed during coexistence;
- an owner and removal condition for every temporary component;
- a single authoritative source for each datum and rule at every phase.

Avoid uncontrolled dual writes. If coexistence requires them, define ordering,
idempotency, conflict resolution, reconciliation, partial-failure recovery, and
which system is authoritative.

## Prove behavior before cutover

Build an oracle from characterization tests, contract tests, approved behavior
changes, and representative production data. Compare old and new at the
observable boundary.

Use the strongest affordable evidence:

- golden-master or differential tests for stable deterministic behavior;
- shadow traffic or dark reads for production-shaped comparison;
- backfill rehearsal and reconciliation for persisted data;
- load and soak tests for latency, throughput, memory, leaks, and failure modes;
- fault injection for retries, timeouts, partial state, and recovery;
- security and permission checks across the new boundary.

Classify mismatches as intended descope, known legacy defect, oracle defect, or
replacement defect. Do not normalize unexplained differences.

## Roll out and retire

Move one slice at a time when possible. For each phase define:

- entry criteria and verified preconditions;
- cohort, route, tenant, operation, or percentage moved;
- health and correctness signals;
- abort threshold and rollback action;
- data reconciliation or downgrade requirements;
- the legacy code and transition machinery deleted after acceptance.

Prefer reversible routing over irreversible cutover until state compatibility is
proven. Once acceptance criteria hold, complete the migration: move remaining
callers, establish the new source of truth, remove the old implementation and
temporary architecture, and verify no fallback silently keeps legacy alive.

## Rewrite rejection criteria

Reject or redesign the rewrite when:

- strict parity is assumed but not inventoried or tested;
- compatibility or migration is assumed rather than explicitly decided per
  contract and data set;
- the scope cannot be split into independently valuable or verifiable slices;
- old and new systems would evolve independently for an open-ended period;
- there is no authoritative data owner during migration;
- cutover depends on unmeasured performance or unexplained output differences;
- rollback cannot restore compatible code and data;
- temporary architecture has no deletion plan;
- the target reproduces the old system's complexity under new names;
- the plan adds a platform, framework, service, or abstraction without deleting
  more operational and cognitive burden than it creates.
