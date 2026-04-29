---
name: core
description: "Use when the user is making, asking about, or evaluating a research-level theoretical physics claim or comparison — about a specific system, mechanism, methodology, recent result, or unexplored regime. Applies to correlated systems, condensed matter, many-body physics, and adjacent topics. Skip for textbook recall (e.g., 'what is BCS pairing'), code/tooling, casual conversation, or algebra inside an active derivation."
---

# renorm:core — Claim Discipline

Two contracts apply whenever this skill fires: **tagging** and **grounding**. Both are non-negotiable.

## Tagging contract

Every substantive claim Claude makes must be tagged with one of:

- `Derived` — follows from explicit equations or derivation visible in this conversation.
- `Assumed` — explicit assumption being made for the discussion. State the assumption.
- `Phenomenological` — fitted or empirical input, not derived.
- `Exploratory` — speculative; not grounded in derivation or literature.
- `Training-knowledge` — Claude's recall of training material; not verified, possibly stale.

Untagged substantive claims are not allowed. If a claim doesn't fit one of these tags, the claim is not ready.

The tags apply to **claims about physics content**, not conversational scaffolding. "Let me think about this step by step" is not a claim; "the cuprate pseudogap is a Mott physics effect" is.

## Grounding contract

Before making claims that depend on prior work (specific systems, mechanisms, recent results), present grounding first:

1. **Default — training-knowledge.** State understanding from training, tagged `Training-knowledge`. Identify:
   - What's known about this topic.
   - What's been tried.
   - What's adjacent in similar systems.

2. **Escalation — only when user asks to "verify", "check", or "look up", or when the claim is obviously high-stakes:**
   - **Zotero MCP first.** The user's curated library is the best first source — search it for relevant papers, fulltext, and the user's own annotations.
   - **WebSearch / arXiv lookup** only if Zotero comes up empty.

3. **No external skill imports.** Anything borrowed from third-party skills (e.g., `yy/claude-scholar`) gets copied into this plugin with attribution at port time, not wired as a runtime dependency.

Each claim points at its grounding (paper, equation, training-knowledge), or honestly says "this is my own connection, not in the literature."

## What this skill does not do

- It does not fire on textbook recall ("explain BCS"), pure tooling questions, code debugging, or casual chat.
- It does not fire on algebraic steps inside an active derivation — those are governed by `renorm:derivation` (which references this skill's tagging vocabulary by name).
- It does not fire on paper-specific reading questions — those are governed by `renorm:paper-analysis`.

The wrappers reference this vocabulary by name; do not duplicate the contract in their SKILL.md files.

## Activation via slash command

If the user explicitly invokes `/renorm <claim>`, apply both contracts to the supplied claim immediately. If `/renorm` is invoked without an argument, apply both contracts to the next exchange.
