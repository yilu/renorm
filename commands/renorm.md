---
description: "Force-invoke renorm:core to apply tagging + grounding discipline. Optional argument: a specific claim to interrogate."
---

# /renorm — force claim discipline

Use the **renorm:core** skill to apply tagging + grounding discipline.

If an argument was provided after `/renorm`, treat it as the specific claim to tag and ground immediately. Tag the claim with one of `Derived` / `Assumed` / `Phenomenological` / `Exploratory` / `Training-knowledge`, present the grounding (training-knowledge by default; offer to verify via Zotero or WebSearch), and stop. Do not extend the claim or add unrelated commentary.

If `/renorm` was invoked without an argument, apply tagging + grounding discipline to the next user statement or the next claim Claude makes in the upcoming exchange.

In both cases, the discipline is non-negotiable: untagged substantive claims are not allowed. If a claim doesn't fit a tag, name the gap.
