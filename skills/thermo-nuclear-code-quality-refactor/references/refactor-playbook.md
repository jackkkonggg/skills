# Refactor Playbook

Use this playbook for behavior-preserving structural improvement and as the
foundation for any authorized rewrite.

## Contents

- [Quality bar](#quality-bar)
- [Ground the real contract](#ground-the-real-contract)
- [Pass the decision gates](#pass-the-decision-gates)
- [Run the descoping checkpoint](#run-the-descoping-checkpoint)
- [Set compatibility and migration policy](#set-compatibility-and-migration-policy)
- [Choose the smallest viable strategy](#choose-the-smallest-viable-strategy)
- [Design the target shape](#design-the-target-shape)
- [Balance cleanliness and performance](#balance-cleanliness-and-performance)
- [Execute in verified slices](#execute-in-verified-slices)
- [Delete the old shape](#delete-the-old-shape)
- [Verify and report](#verify-and-report)
- [Stop conditions](#stop-conditions)

## Quality bar

Seek a code-judo move: reorganize ownership, state, or control flow so entire
branches, modes, helpers, compatibility layers, or concepts disappear. Prefer
deleting complexity to redistributing it. The best architecture is the least
architecture that makes invariants, ownership, and change boundaries obvious.

Do not optimize for line count alone. Optimize for fewer concepts, shorter
reasoning paths, explicit contracts, local change, testability, and measured
runtime cost.

Treat these as presumptive design failures:

- new special-case conditionals scattered through unrelated flows;
- booleans or nullable modes that create invalid state combinations;
- pass-through wrappers, identity abstractions, and generic machinery with one
  real use;
- feature logic in shared infrastructure or implementation details exposed
  through public APIs;
- duplicate canonical helpers, validators, caches, schemas, or state;
- casts, `any`, `unknown`, optionality, or silent fallback that obscure an
  invariant the boundary could express;
- a file crossing 1,000 lines because the change has no coherent home;
- sequential independent work or partial updates that make orchestration harder
  to reason about;
- a second implementation with no migration owner or removal condition;
- speculative performance complexity without a baseline or budget.

## Ground the real contract

Before proposing a shape, trace the behavior that exists rather than the
behavior implied by names or tests.

Inventory:

- entry points, callers, consumers, and externally observable outputs;
- public APIs, events, persisted formats, migrations, and compatibility promises;
- side effects, ordering, retries, idempotency, errors, timeouts, and fallbacks;
- permissions, trust boundaries, concurrency, and partial-failure behavior;
- tests, production incidents, telemetry, historical decisions, and known users;
- latency, throughput, memory, allocation, startup, bundle, I/O, and cost facts
  relevant to the requested change.

Create characterization tests for important retained unpinned behavior before
moving it. Do not characterize explicitly authorized deletions. Record baseline
test and performance commands and their exit status. Measure suspected hot
paths; do not attribute cost from intuition.

Use `blast-radius` before deleting or moving a shared contract. Use `tdd` for a
retained bug or new contract with a cheap failing-first path. Use
`thermo-nuclear-code-quality-tests` when tests are added, rewritten, pruned, or
questioned. Use `architect` when changing ownership, public types, module
boundaries, or persisted data.

## Pass the decision gates

Run the mandatory and applicable conditional gates in
[decision-gates.md](decision-gates.md) before choosing the target architecture.
Keep one ledger of decisions and evidence. Batch unresolved questions so the
user can decide related tradeoffs together; do not re-ask decisions already
made in the request or repository evidence.

Gates front-load consequential choices, but they are not phase approvals or a
reason to stall low-risk work. Mark a conditional gate not applicable when its
trigger is absent. Reopen a passed gate only when new evidence, scope, or design
invalidates its basis.

## Run the descoping checkpoint

Make product simplification an explicit decision before architecture hardens.
Prepare a compact ledger with:

| Candidate | Evidence | Complexity removed | User-visible impact | Recommendation |
|---|---|---|---|---|
| Feature, mode, compatibility path, edge case, or guarantee | Callers, usage, telemetry, tests, or history | Branches, APIs, state, dependencies, migration work | Exact behavior that disappears | Remove, retain, or investigate |

Ask the user: **Can any of these be removed or narrowed to make the system
cleaner? If not, should the refactor preserve strict behavior and compatibility
parity?**

Do not silently remove behavior because it appears unused, undocumented,
untested, obsolete, or inconvenient. Absence of evidence is not deletion
authority. If the user already made an explicit parity or descoping decision,
record it and do not ask again.

Separate four categories:

- required current behavior;
- explicitly removable behavior;
- unknown behavior that needs evidence;
- internal incidental behavior that is safe to change because it is not
  observable and has no contract.

## Set compatibility and migration policy

Treat backward compatibility and migration as separate product decisions. A
breaking API cutover may still require preserving or transforming stored data;
permission to drop old contracts is not permission to discard data.

Ask the user: **Must existing clients or stored data be migrated, and must old
APIs, contracts, events, formats, CLI, or configuration remain backward
compatible? If yes, which surfaces, for how long, and what ends support? If no,
may the legacy surfaces and adapters be deleted instead of reimplemented?**

Record the answer per surface:

| Surface or data | Consumers | Decision | Migration | Support ends | Removal proof |
|---|---|---|---|---|---|
| API, event, schema, file format, CLI, config, or persisted data | Known callers or owners | Retain, bridge temporarily, break, or remove | Transform, export, backfill, or none | Date or measurable condition | Search, telemetry, contract test, or owner sign-off |

When compatibility is required, keep translation at a narrow boundary and use
one canonical internal model. Give every version adapter, dual reader or writer,
deprecated endpoint, and feature flag an owner and retirement condition. Avoid
letting legacy branches spread through the new core.

When compatibility is not required, simplify aggressively: remove old
endpoints, version dispatch, shims, parsers, schemas, configuration aliases,
dual-read or dual-write paths, tests, docs, and dependencies that exist only for
the legacy contract. Do not preserve them “just in case.” Still honor explicit
data-retention, security, legal, audit, export, and rollback obligations.

## Choose the smallest viable strategy

Choose the least risky strategy that can reach the target:

1. **Local refactor** — improve one cohesive area behind the same interface.
2. **Preparatory refactor** — create a seam or clarify ownership before moving
   behavior.
3. **Incremental replacement** — move callers or traffic slice by slice while
   old and new implementations temporarily coexist.
4. **Rewrite** — replace a bounded unit when incremental improvement cannot
   reasonably reach the target. A rewrite still needs contract, migration,
   parity, rollout, and rollback evidence.

Prefer a local or preparatory refactor unless evidence demonstrates that the
current shape blocks the target. Do not use a rewrite to avoid understanding the
existing system.

For a consequential change, compare at least two concrete shapes using real
callers, types, module ownership, migration steps, and performance implications.
Reject alternatives explicitly; avoid a vague compromise that inherits every
candidate's complexity.

## Design the target shape

Write the target in terms of responsibilities and invariants:

- one canonical owner for each rule and state transition;
- explicit boundary parsing and trusted internal types;
- direct data flow and short call chains;
- pure domain logic where practical, with side effects at visible edges;
- invalid states made unrepresentable where that simplifies control flow;
- cohesive modules deep enough to hide complexity, not wrappers around it;
- stable interfaces shaped around callers rather than current internals;
- failure, concurrency, and atomicity semantics visible in the API;
- a deletion map naming old modules, flags, adapters, and tests that disappear.

Prefer existing canonical helpers and conventions. Add a new abstraction only
when it removes duplicated knowledge, branches, invalid states, lifecycle risk,
or caller burden. Keep clear local code when extraction would only add a jump.

## Balance cleanliness and performance

Clean structure is the default; measured constraints justify exceptions.
Apply this section when performance or resource use is in scope, the change
touches a known hot path, or an improvement is claimed. Otherwise record why
performance is not applicable and do not manufacture a benchmark.

1. Define the relevant budget before editing: for example p50/p95 latency,
   throughput, peak memory, allocations, startup time, bundle size, query count,
   I/O volume, or infrastructure cost.
2. Capture a representative baseline with warmup, realistic data, and the same
   environment used for comparison.
3. Design the simplest implementation expected to meet the budget.
4. Measure the result. Optimize only the observed limiting path.
5. Isolate unavoidable complexity behind a narrow interface and document the
   measured reason, dataset, command, and threshold that justify it.

Do not trade maintainability for a microbenchmark win that does not affect a
user or operational budget. Do not call a refactor faster without before/after
measurements. Preserve semantic details such as ordering, batching, cache
invalidation, backpressure, and atomicity when optimizing.

## Execute in verified slices

Keep behavior changes separate from structural changes unless the user approved
them together and separation would make the system less safe.

For each slice:

1. State the retained invariant and any explicitly authorized deletion.
2. Add or identify the cheapest direct test for retained or new contracts. Do
   not pin deleted behavior.
3. Make one coherent ownership, data-shape, or control-flow change.
4. Run the narrow test, then the relevant broader suite; trust exit status.
5. Measure performance when the slice touches a budgeted path.
6. Inspect the diff for accidental scope, duplicated logic, and temporary code.
7. Keep the build and migration state usable before proceeding.

Prefer small, reviewable slices over a long-lived refactor branch. Use temporary
adapters only when they reduce migration risk; name their retirement condition
and remove them promptly.

## Delete the old shape

A refactor is incomplete while two sources of truth remain.

- Migrate callers before deleting the old API.
- Remove dead branches, flags, wrappers, compatibility shims, imports, tests,
  docs, configuration, and dependencies tied only to the old path.
- Prove unreachability or absence of consumers before deletion. Ask when
  external use cannot be established.
- Remove transitional instrumentation and dual-run machinery after acceptance.
- Re-run searches after deletion; no stale names or fallback paths should remain.

Do not leave “temporary” complexity without an owner, deadline or condition,
and a reliable way to detect when removal is safe.

## Verify and report

Run the cheapest evidence that directly proves each relevant claim:

- characterization, unit, integration, end-to-end, migration, and failure tests;
- typecheck, lint, build, schema, and compatibility checks;
- security and concurrency checks where boundaries changed;
- before/after performance measurements against the agreed budget when relevant;
- caller and dead-code searches;
- rollback or downgrade rehearsal when deployment state changed;
- a `thermo-nuclear-code-quality-tests` audit when test scope changed;
- a final `thermo-nuclear-code-quality-review` of the actual diff.

Report:

- mandatory and triggered gate states, decisions, and evidence;
- agreed preserved behavior and accepted descopes;
- chosen strategy and rejected alternatives;
- target ownership and architecture;
- concepts, branches, interfaces, dependencies, and old code removed;
- performance baseline, result, budget, and measurement method, or why they are
  not applicable;
- validation commands and exit statuses;
- migration, rollout, rollback, remaining risks, and follow-up removals.

## Stop conditions

Pause rather than guess when:

- a mandatory or triggered decision gate remains blocked;
- the user has not decided a behavior, compatibility, or feature descope;
- client migration, data migration, and backward-compatibility requirements
  have not been decided independently;
- no test or oracle can distinguish correct from incorrect behavior;
- external consumers, persisted data, or migration state are unknown;
- the rewrite boundary or rollback path is undefined;
- performance goals conflict with correctness or maintainability and no budget
  identifies the intended tradeoff;
- the proposed target adds concepts without deleting equivalent complexity;
- the change expands beyond the requested subsystem or authority.
