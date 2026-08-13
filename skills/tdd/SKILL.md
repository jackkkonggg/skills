---
name: tdd
description: Use for requested TDD, focused regression tests, or bugs with an obvious cheap executable test path.
---

# TDD

Make the broken behavior executable before changing production code when a
clear, cheap test path exists.

1. Classify the intended contract as retained, new, or explicitly deleted. TDD
   applies to retained bugs and new behavior. For an authorized deletion, do not
   reproduce the retired behavior; use `thermo-nuclear-code-quality-tests` to
   remove obsolete coverage and protect only retained neighboring contracts.
2. Identify intended behavior, current behavior, and the smallest observable
   reproduction.
3. Choose the nearest existing unit, component, integration, or regression
   harness.
4. Add the smallest test that encodes behavior rather than implementation.
5. Run it before the fix and confirm it fails for the intended reason.
6. Make the smallest production change that satisfies the contract.
7. Rerun the focused test, then nearby validation proportional to risk. Use
   `thermo-nuclear-code-quality-tests` to prove the new test's sensitivity.

Load [references/workflow.md](references/workflow.md) for flaky bugs, unclear
harness choices, or cases where failing-before evidence may be impractical.

Do not build broad infrastructure, brittle mocks, or unrelated fixtures merely
to claim TDD. Do not weaken assertions to match a wrong implementation. When a
useful failing test is impractical, say why before fixing and use the closest
executable check, such as a targeted script, browser reproduction, snapshot, or
focused integration check.

Report the failing-before evidence, passing-after evidence, nearby validation,
and any gap that prevented a true regression test.
