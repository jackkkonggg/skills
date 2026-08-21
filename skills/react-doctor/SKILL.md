---
name: react-doctor
description: Use to scan, triage, and fix React diagnostics before finishing or committing React changes.
---

# React Doctor

Scan React codebases for security, performance, correctness, and architecture issues.

Run commands from the React project directory containing `package.json`. When operating elsewhere, pass the target directory as the first argument, for example `pnpm dlx react-doctor@latest /path/to/project --verbose`.

## After React code changes

Run `pnpm dlx react-doctor@latest --verbose --scope changed`. Fix any introduced issues and score regressions before committing.

For general cleanup, run `pnpm dlx react-doctor@latest --verbose` and fix errors before warnings.

For a focused UI audit, run `pnpm dlx react-doctor@latest design --verbose`.

## For runtime performance problems:

Run `npx react-doctor@latest scan <url> --format json` interactively. It records a DevTools trace while the user reproduces the slow interaction. Read the summary, then inspect the local `.json.gz` trace.

For authenticated browser state, use `--cdp <remote-debugging-url>` with an existing remote-debugging session. Never request cookies, copy a browser profile, or upload traces without permission.

## /doctor — full local triage workflow

When the user types `/doctor`, asks to run React Doctor, or requests full triage, fetch and follow the canonical playbook:

```bash
curl --fail --silent --show-error \
  --header 'Cache-Control: no-cache' \
  https://www.react.doctor/prompts/react-doctor-agent.md
```

The playbook defines the scan, triage, fix, and validation loop. Edit the working tree directly; never commit or open a PR.

## Configuring or explaining rules

For rule changes, read [references/explain.md](references/explain.md), run `pnpm dlx react-doctor@latest rules explain <rule>`, and apply the narrowest control.
