# Changelog

All notable changes to renorm will be documented in this file.

## [Unreleased]

## [0.2.0] - 2026-04-29

### Added
- `renorm:derivation` skill: derivation-ledger discipline for theoretical-physics derivations. Ports `~/.codex/skills/derivation-first-modeling` (a 10-field ledger) into a 6-field ledger plus a lightweight 3-line collapsed form for exploratory expansions. References `renorm:core`'s tagging vocabulary instead of duplicating it.
- `/derive` slash command: deterministic invocation of the derivation skill, optionally accepting a derivation goal as argument.

## [0.1.0] - 2026-04-29

### Added
- `renorm:core` skill: tagging contract (`Derived` / `Assumed` / `Phenomenological` / `Exploratory` / `Training-knowledge`) plus grounding contract (training-knowledge default, escalation to Zotero MCP / WebSearch on demand) for research-level theoretical-physics conversations.
- `renorm:init-package` skill: consolidated Python / Julia / C++ scientific-computing scaffolding via bundled templates.
- `/renorm <claim>` slash command: deterministic invocation of the core skill, with optional argument.
- `marketplace.json`: registers the repo as a single-plugin marketplace so the plugin is installable via `/plugin install renorm@renorm`.
