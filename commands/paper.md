---
description: "Force-invoke renorm:paper-analysis on a specific paper. Argument: arXiv ID, DOI, or local PDF path."
---

# /paper — analyze a specific paper

Use the **renorm:paper-analysis** skill to apply quote-before-claim discipline.

If an argument was provided after `/paper`, treat it as the paper reference:
- An arXiv ID (e.g., `2104.01234`) → fetch from arXiv.
- A DOI (e.g., `10.1103/PhysRevB.107.094510`) → fetch via DOI resolver.
- A local path (e.g., `~/papers/foo.pdf`) → read the file directly.

If no argument was given, ask: "Which paper? (arXiv ID, DOI, or local PDF path)" and wait for the answer.

In either case, structure all output in the three buckets `Paper-claim` / `Inference` / `Connection`, attach a `Depends on` line to every quoted result, and name gaps explicitly when the user asks about anything the paper doesn't cover. Do not summarize from the abstract alone.
