# Test Quality Playbook

## Build the contract ledger

Audit only the requested behavior, subsystem, package, or suite. For each
affected contract record:

| Contract | Class | Evidence | Distinct risk | Tests | Action |
|---|---|---|---|---|---|
| Observable outcome or invariant | Retained, new, deleted, or unknown | User decision, API, incident, caller, or requirement | Regression this catches | Owning tests | Keep, add, rewrite, delete, or investigate |

- **Retained** behavior needs proportional protection.
- **New** behavior needs acceptance evidence; use `tdd` when failing-first is
  cheap and meaningful.
- **Deleted** behavior needs explicit authority and removal evidence, not a
  characterization test.
- **Unknown** behavior needs investigation or a user decision before deletion.

## Judge usefulness

Keep or create a test only when it:

- names a durable observable contract, invariant, failure semantic, or security
  boundary;
- fails for a realistic regression in that contract;
- provides a distinct signal not already proven more directly elsewhere;
- uses the nearest reliable surface without mostly testing mocks or internals;
- is deterministic enough to trust and cheaper to maintain than the confidence
  it contributes.

Prefer one strong outcome test over several branch-shaped tests. Remove or
rewrite tests coupled to private helpers, incidental call order, obsolete
snapshots, duplicated paths, tautologies, or mocks that only verify themselves.
Do not retain a test merely because it raises coverage.

## Handle authorized deletion

Delete tests and test infrastructure whose only purpose is the retired contract.
Do not create a failing test that asks the new implementation to reproduce the
old behavior. Prove the change with the authorization record, searches showing
the obsolete path is gone, and focused tests for retained neighboring outcomes.

Keep a negative or absence assertion only when absence is durable product
behavior, such as denied access, rejected invalid input, or an explicitly empty
fallback. For example, if sanitizer and degradation behavior is deleted while
the required contract is “bitmap failure leaves the overlay empty and playback
continues,” delete the old internal-behavior tests and keep that outcome test.

## Prove test sensitivity selectively

Require proof for:

- every new test;
- every materially rewritten test whose asserted contract, oracle, harness, or
  fixtures changed;
- every retained test whose contract, distinct value, or sensitivity is in
  doubt.

Clearly valuable unchanged tests are exempt. Do not expand mutation work beyond
the explicit audit scope.

Use an existing mutation framework when configured. Otherwise make one
reversible, meaningful violation of the named production contract:

1. Preserve the exact pre-mutation file in a task-owned temporary copy and
   record its hash. Never use `git restore`, `git checkout`, or another operation
   that could erase user work.
2. Introduce one plausible contract-breaking change, not a syntax error or
   arbitrary implementation perturbation.
3. Run the exact claimed test. It must fail for the intended contract violation.
4. Restore the file byte-for-byte from the task-owned copy; confirm its hash and
   diff match the pre-mutation state.
5. Rerun the test and confirm it passes.

If the test survives, strengthen it, remove it, or reclassify it with evidence.
Never weaken the mutation or assertion merely to manufacture a kill. Do not
mutate live systems, external state, generated sources, or data that cannot be
restored safely.

## Treat coverage as diagnostic

Use coverage to find unexamined risk, not as a target. Authorized deletion may
lower a percentage legitimately. If an enforced threshold fails, do not add
filler tests or silently edit coverage configuration. Report the exact conflict
and ask for authority to lower, remove, or retain the policy.

## Finish the audit

Run focused tests first, then the smallest broader suite that covers shared
fixtures, public boundaries, and changed setup. Trust exit status. Inspect the
final diff for orphaned fixtures, snapshots, helpers, mocks, imports, and test
dependencies. Report sensitivity proofs only for tests that required them and
name clearly valuable unchanged tests that were exempt.
