# renorm

**R**esearch **E**pistemics: **N**ote, **O**bserve, **R**eference, **M**odel.

A Claude Code plugin that imposes claim-tagging and literature-grounding discipline on research-level theoretical-physics conversations, with scaffolding for Python / Julia / C++ scientific computing packages.

> **Status:** Pre-release (v0.1.0). Active development; README and trigger language will be refined after a dogfooding period. File issues if curious.

## Install

In Claude Code, register the marketplace and install the plugin:

```
/plugin marketplace add yilu/renorm
/plugin install renorm@renorm
```

(The repo serves as both the plugin source and a single-plugin marketplace.)

For local development without installing, use the `--plugin-dir` flag:

```bash
claude --plugin-dir /path/to/renorm
```

## What it does

| Skill | Purpose |
|---|---|
| `renorm:core` | Tags every substantive physics claim (`Derived` / `Assumed` / `Phenomenological` / `Exploratory` / `Training-knowledge`). Grounds claims in literature when prior work matters; defaults to training-knowledge with explicit tagging, escalates to Zotero MCP or WebSearch on user request. |
| `renorm:init-package` | Scaffolds a new Python / Julia / C++ scientific-computing package with reproducibility conventions (RNG seeding, units in comments, type hints) baked in. |

## Slash commands

- `/renorm <claim>` — force-invoke the core skill on a specific claim, or apply discipline to the next exchange.

## Trigger language

Auto-triggers (via SKILL.md `description` fields) are **subject to revision**. Refine after a week of real use.

## Future versions

- v0.2 will add `renorm:derivation` (a derivation ledger discipline ported from the author's existing Codex-side skill).
- v0.3 will add `renorm:paper-analysis` (quote-before-claim discipline for reading specific papers).

## License

MIT.
