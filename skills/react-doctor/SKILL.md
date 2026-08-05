---
name: react-doctor
description: Use to scan, triage, and fix React diagnostics before finishing or committing React changes.
version: "1.2.0"
---

# React Doctor

Scans React codebases for security, performance, correctness, and architecture issues, producing a 0–100 health score.

## After React code changes

Run `npx react-doctor@latest --verbose --scope changed`. Fix any introduced issues and score regressions before committing.

For general cleanup, run `npx react-doctor@latest --verbose` and fix errors before warnings.

For a focused UI audit, run `npx react-doctor@latest design --verbose`.

## /doctor — full local triage workflow

When the user types `/doctor`, asks to run React Doctor, or requests full triage, fetch and follow the canonical playbook:

```bash
curl --fail --silent --show-error \
  --header 'Cache-Control: no-cache' \
  https://www.react.doctor/prompts/react-doctor-agent.md
```

The playbook is the source of truth for its scan → filter → triage → fix → validate loop. Edit the working tree directly; never commit or open a PR. Fetch matching rule prompts on demand as directed there.

## Configuring or explaining rules

When explaining or tuning rules, read [references/explain.md](references/explain.md), run `npx react-doctor@latest rules explain <rule>`, and apply the narrowest `rules disable|set|category|ignore-tag` control.
