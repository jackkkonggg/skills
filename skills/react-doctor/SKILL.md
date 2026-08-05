---
name: react-doctor
description: Use to scan, triage, and fix React diagnostics before finishing or committing React changes.
---

# React Doctor

Scans React codebases for security, performance, correctness, and architecture issues, producing a 0–100 health score.

Run commands from the React project directory containing `package.json`. When operating elsewhere, pass the target directory as the first argument, for example `pnpm dlx react-doctor@latest /path/to/project --verbose`.

## After React code changes

Run `pnpm dlx react-doctor@latest --verbose --scope changed`. Fix any introduced issues and score regressions before committing.

For general cleanup, run `pnpm dlx react-doctor@latest --verbose` and fix errors before warnings.

For a focused UI audit, run `pnpm dlx react-doctor@latest design --verbose`.

## /doctor — full local triage workflow

When the user types `/doctor`, asks to run React Doctor, or requests full triage, fetch and follow the canonical playbook:

```bash
curl --fail --silent --show-error \
  --header 'Cache-Control: no-cache' \
  https://www.react.doctor/prompts/react-doctor-agent.md
```

The playbook is the source of truth for its scan → filter → triage → fix → validate loop. Edit the working tree directly; never commit or open a PR. Fetch matching rule prompts on demand as directed there.

## Configuring or explaining rules

When explaining or tuning rules, read [references/explain.md](references/explain.md), run `pnpm dlx react-doctor@latest rules explain <rule>`, and apply the narrowest `rules disable|set|category|ignore-tag` control.
