---
name: paper-analysis
description: "Use when summarizing, analyzing, or extending claims from a specific paper (arXiv ID, DOI, or local PDF). Applies a quote-before-claim discipline: every assertion about the paper's content must be backed by a direct quote, equation reference, or figure reference. Not for general 'what does field X say' questions, which go to renorm:core; not for actively performing your own derivation, which goes to renorm:derivation."
---

# renorm:paper-analysis — Paper Reading Discipline

When analyzing a specific paper, separate **what the paper claims** from **what you are inferring** from **what you are bringing in from elsewhere**. Conflating these is the most common failure mode in physics paper discussions.

## Three-bucket reporting

Every output structured as three explicit buckets:

- **`Paper-claim`** — a direct quote, equation reference (`Eq. 12`), or figure reference (`Fig. 3, the χ=400 curve`). The paper said this in these words. If you cannot quote or cite a specific equation/figure, it is not a `Paper-claim`.
- **`Inference`** — your own derivation, calculation, or logical step starting from what the paper said. Make the inference chain explicit; do not present it as the paper's claim.
- **`Connection`** — context you are bringing in from elsewhere: another paper, a textbook, a related system, training knowledge. Tag the source if known; if it's training knowledge, mark it as such per `renorm:core`'s `Training-knowledge` tag.

Untagged content — prose that doesn't fit any of these buckets — is not allowed in a paper-analysis output.

## Mandatory assumptions line

Every `Paper-claim` that reports a result (a number, a phase, a behavior, a scaling) must come with a one-line statement of what the result depends on:

> *Depends on:* lattice / approximation / symmetry / parameter regime / numerical method.

If the paper doesn't state these explicitly, infer the most likely set from context and tag your inference accordingly.

Examples:
- `Paper-claim: "Pseudogap onset at T* ≈ 200 K" (Eq. 7).`
  *Depends on:* hole doping x = 0.10, single-band Hubbard model, DMFT solver with bath truncation N_b = 6.
- `Paper-claim: "Critical exponent α = 1.2 ± 0.1" (Fig. 4).`
  *Depends on:* finite-size scaling on L = 24-96 cubes, periodic boundary conditions, Monte Carlo with seed-averaged statistics.

A result without a `Depends on` line is incomplete reporting.

## Don't extend silently

If the user asks about a regime, lattice, limit, or system that the paper does **not** cover, name the gap before speculating.

Required form:

> *Gap:* the paper covers [what's covered], not [what was asked]. Extending requires [what assumption / approximation / additional model].

Then, and only then, may you offer an `Inference` or `Connection` about the extension.

Forbidden:
- Treating the paper as if it covered something it didn't.
- Quietly importing parameters / regimes that the paper rejected or didn't address.
- Using the paper's framework outside its stated regime without flagging the extrapolation.

## Tagging vocabulary

The three reporting buckets above (`Paper-claim` / `Inference` / `Connection`) are **specific to paper analysis**. They are not the same as `renorm:core`'s tagging vocabulary (`Derived` / `Assumed` / `Phenomenological` / `Exploratory` / `Training-knowledge`).

For non-paper claims that arise during analysis — a side comment, a derivation step, a speculative extension — apply `renorm:core`'s tags as usual. The two systems compose cleanly:

- `Inference` is structurally similar to `Derived` but bound to *the paper's claims as starting point*.
- `Connection` from training knowledge should be additionally tagged `Training-knowledge` per the core skill.

## Workflow

1. **Identify the paper.** Confirm arXiv ID, DOI, or local PDF path. If the user gives an ambiguous reference, ask before guessing.

2. **Read what's actually there.** Do not summarize from the abstract alone. Identify:
   - Methods section — what was computed, with what tools, in what regime.
   - Results section — what was found, in what figures/tables.
   - Discussion / Conclusion — what the authors claim follows.
   - Assumptions and approximations — explicit and implicit.

3. **Structure the output** in the three buckets, with assumptions lines on every quoted result.

4. **Name gaps explicitly** if the user's question goes beyond the paper.

5. **Cite locations** for every `Paper-claim` — equation number, figure caption, section heading, or page number.

## Red flags

Stop if any of these appear:

- Summarizing the abstract and presenting it as the paper's content.
- Reporting a result without a `Depends on` line.
- Using "the paper shows that..." for an `Inference` (your own logic).
- Using "the paper shows that..." for a `Connection` (your context-bringing).
- Extending the paper's claims to a regime / lattice / limit without naming the gap.
- Citing without quoting — "the paper says X" without a direct quote or equation reference.

## Activation via slash command

If the user invokes `/paper <ref>`, treat the argument as the paper to analyze:
- arXiv ID like `2104.01234` → fetch from arXiv.
- DOI like `10.1103/PhysRevB.107.094510` → fetch via the DOI resolver.
- Path like `~/papers/foo.pdf` → read the local file.

If no argument was given, ask which paper before proceeding.
