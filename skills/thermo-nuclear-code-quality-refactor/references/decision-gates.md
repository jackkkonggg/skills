# Refactor Decision Gates

Use gates to expose consequential decisions before architecture hardens, not to
create ceremony. Ask only what repository evidence and prior user instructions
cannot answer. Batch related questions and never re-ask a settled decision.

Keep a compact ledger:

| Gate | Trigger | Decision or constraint | Evidence | State |
|---|---|---|---|---|
| Name | Always or observed condition | Answer, budget, or boundary | User decision, test, telemetry, search, or measurement | Pass, blocked, or not applicable |

Do not edit while a mandatory or triggered gate is blocked. A gate passes when
its decision is explicit and the plan can honor it; implementation proof comes
later. Re-evaluate only when scope, evidence, or the proposed design changes.

## Mandatory gates

1. **Outcome** — Ask: “What measurable outcome justifies this work, and what
   would make it unsuccessful?” Pass with a concrete improvement and guardrails;
   reject a purely aesthetic rewrite.
2. **Scope and descope** — Present specific removable or narrowable features,
   modes, edge cases, and guarantees. Ask what may go; otherwise confirm strict
   behavior parity. Never infer deletion authority from low usage or weak tests.
3. **Compatibility and migration** — Ask separately whether existing clients or
   data must migrate and whether old APIs, events, formats, CLI, or configuration
   remain supported. Record each retained surface, duration, and retirement
   condition; without compatibility, plan to delete the legacy paths.
4. **Rewrite justification** — Ask whether a local or preparatory refactor can
   reach the outcome. Pass a replacement only with evidence that the current
   shape blocks the target and a bounded rewrite is safer or materially better.
5. **Correctness oracle** — Identify how correct and incorrect behavior will be
   distinguished: characterization, contract or differential tests, production
   samples, invariants, or another reliable oracle.
6. **Architecture deletion** — Name the concepts, modules, branches,
   dependencies, or sources of truth that disappear. Redesign proposals that
   only add layers or redistribute equivalent complexity.
7. **Completion** — Define the deletion end-state and acceptance evidence,
   including removal of obsolete flags, adapters, fallbacks, schemas, tests,
   documentation, dependencies, and transitional machinery.

## Conditional gates

8. **Data semantics** — Trigger when the change alters persisted, cached,
   streamed, or queued data semantics, ownership, or representation, or requires
   migration. Decide loss tolerance, ordering, idempotency, authority, backfill,
   reconciliation, retention, export, and rollback semantics.
9. **Rollout and reversibility** — Trigger when the change requires a staged
   deployment or cutover, or can alter live state in a way code rollback cannot
   undo. Define stages, health signals, abort thresholds, rollback actions, and
   whether rollback remains valid after data changes.
10. **Performance budget** — Trigger for a hot path, performance claim, or
    material resource change. Set the metric, representative workload, baseline,
    target budget, and tolerated regression before optimizing.
11. **Security and compliance** — Trigger when trust boundaries, permissions,
    secrets, personal data, auditability, or regulated retention may change.
    Preserve the explicit threat, access, audit, and retention requirements.
12. **Dependency and platform** — Trigger when adding or replacing a framework,
    service, runtime, protocol, datastore, or major dependency. Require authority
    and show which larger operational or cognitive burden it removes.
13. **Operational ownership** — Trigger when the change crosses team boundaries,
    changes operational responsibility, or introduces migration or temporary
    production machinery. Name owners for deployment, incidents, migration,
    observability, communication, and cleanup.
14. **Time horizon** — Trigger when durability is unclear. Decide whether the
    system is short-lived, product-lived, or platform-lived and size the design,
    compatibility investment, and migration machinery accordingly.

## Blocking rule

Pause for user direction when a gate exposes a product, compatibility, data,
security, operational, or cost decision outside the agent's authority. Continue
when evidence resolves the gate or the user has already accepted the tradeoff.
Do not manufacture a blocker for a conditional gate that is genuinely not
applicable.
