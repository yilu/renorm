# renorm

**R**esearch **E**pistemics: **N**ote, **O**bserve, **R**eference, **M**odel.

A Claude Code plugin that imposes claim-tagging, literature-grounding, derivation, and paper-reading discipline on research-level theoretical-physics conversations. Bundles scientific-computing package scaffolding for Python / Julia / C++.

> **Status:** v0.3.0 completes the initial discipline-skill set. Trigger language (the `description` field in each SKILL.md) and this README are subject to revision based on real use; the skills themselves are stable. File issues if you find under- or over-firing.

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
| `renorm:core` | Tags every substantive physics claim (`Derived` / `Assumed` / `Phenomenological` / `Exploratory` / `Training-knowledge`). Grounds claims in literature when prior work matters: defaults to training-knowledge with explicit tagging, escalates to Zotero MCP or WebSearch on user request. |
| `renorm:derivation` | Enforces a derivation-ledger discipline. Full derivations get a 6-field ledger (target / variables / what's neglected / starting equations / approximation level / falsification check); exploratory expansions get a lightweight 3-line ledger. References `renorm:core`'s tagging vocabulary. |
| `renorm:paper-analysis` | Enforces quote-before-claim when analyzing a specific paper: three-bucket reporting (`Paper-claim` / `Inference` / `Connection`), a mandatory `Depends on:` line for every quoted result, and explicit gap-naming when the user asks about regimes the paper doesn't cover. |
| `renorm:init-package` | Scaffolds a new Python / Julia / C++ scientific-computing package with reproducibility conventions (RNG seeding, units in comments, type hints) baked in. |

## Slash commands

- `/renorm <claim>` — force-invoke `renorm:core`'s tagging + grounding on a specific claim, or apply discipline to the next exchange.
- `/derive [observable]` — start a fresh `renorm:derivation` ledger, optionally with the observable target as argument.
- `/paper <ref>` — analyze a specific paper (arXiv ID, DOI, or local PDF path) under `renorm:paper-analysis`.

## Composition

The three discipline skills compose by reference rather than firing simultaneously:

- `renorm:core` fires on research-level physics conversations *outside* active derivation or paper analysis.
- `renorm:derivation` fires when actively deriving and incorporates `core`'s tagging vocabulary by reference.
- `renorm:paper-analysis` fires when a specific paper is the subject and incorporates `core`'s tagging for non-paper claims that arise.

Wrappers do not depend on `core` firing in parallel — they reference its vocabulary, so the discipline is preserved regardless of which skill activates.

## License

MIT.
