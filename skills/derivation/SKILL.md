---
name: derivation
description: "Use when actively performing a theoretical derivation — including exploratory expansions and back-of-envelope estimates: writing equations, applying approximations (perturbation, mean-field, saddle-point, downfolding), expanding to a given order, computing a spectrum or response. Ledger weight scales with derivation complexity — short exploratory derivations get a lightweight 3-line ledger; full derivations get the 6-field form. Not for discussing existing derivations from a paper (use renorm:paper-analysis) or pure conceptual comparison (use renorm:core)."
---

# renorm:derivation — Derivation Ledger

Work from problem definition to assumptions to equations to code, not the reverse.

This skill applies the **tagging contract** defined in `renorm:core` (`Derived` / `Assumed` / `Phenomenological` / `Exploratory` / `Training-knowledge`) to claims made during a derivation. The ledger discipline below is **additional structure on top of tagging**, not a replacement.

## Hard Gate

Before writing theory code, updating notes with new equations, or reporting a new theoretical or numerical result, produce a **derivation ledger**.

For **full derivations** intended to produce trustworthy results — the 6-field form:

```
Derivation ledger
- Observable target:
- Primary variables / objects:
- Held fixed / neglected / integrated out:
- Starting equations:
- Approximation level:
- Falsification check:
```

For **exploratory expansions** or back-of-envelope estimates — the 3-line collapsed form:

```
- Expanding around: <reference state / unperturbed limit>
- Keeping: <orders / terms retained>
- Neglecting: <orders / terms dropped>
```

The collapsed form upgrades to the 6-field form if the derivation produces results that get cited or coded. Until then, the lightweight ledger is sufficient.

Do not skip the ledger. Do not compress it into vague prose. Do not write theory code or equations before the ledger exists.

## When to use

Use when:
- deriving or modifying a theoretical model
- comparing alternative formulations of the same problem
- introducing a closure, ansatz, truncation, approximation, or fitting form
- turning equations into a numerical script
- deciding whether a computational result supports a theoretical claim
- checking whether two notations, conventions, or parameterizations are actually equivalent

Do not use for:
- straightforward algebra inside an already-frozen derivation
- purely editorial note cleanup with no model content change
- discussing the contents of an existing paper (that is `renorm:paper-analysis`)
- conceptual comparison without a concrete derivation in progress (that is `renorm:core`)

## Required Workflow

### 1. Freeze the target

State exactly what is being computed. Examples:
- local spectrum
- dispersion relation
- susceptibility or response function
- asymptotic scaling law
- saddle-point equations
- fitted parameter extraction
- stability criterion

If the target is unclear, stop and clarify it before continuing.

### 2. Freeze the objects

State explicitly:
- what the primary variables or operators are
- what is fixed externally and what is solved for
- what can change under later refinement and what is frozen for the present step

If the problem does not use a Hilbert space, say so and state the relevant objects instead: fields, correlators, order parameters, distributions, fitting functions, or matrices.

### 3. Write the starting equations

Write the governing equations and definitions before introducing approximations.

Minimum standard:
- defining equations
- coupling terms or constraints
- target observable or comparison quantity
- notation map if two conventions are being compared

### 4. State the approximation level

Examples:
- strong-coupling projection
- Löwdin downfolding
- perturbation theory to a stated order
- saddle point / mean field
- continuum limit
- linearization
- static kernel
- dynamical self-energy
- slave-boson saddle point

**Only one new approximation layer per implementation step.** If a derivation introduces multiple new approximations at once, split it.

### 5. Fill the ledger

Use the 6-field template (or the 3-line collapsed form for exploratory work). Tag each claim made during the derivation per `renorm:core`.

### 6. Implement one layer only

If converting to numerics, one script should do **one** of:
- local benchmark
- parameter scan
- static kernel
- dynamical correction
- fitted observable
- stability check
- reduced benchmark problem

If a script mixes multiple new layers, split it.

### 7. Verify against the declared falsification check

Before trusting a result, compare to one of:
- exact diagonalization / known solvable limit
- known symmetry / degeneracy
- analytically solvable limit
- limiting parameter regime
- consistency with definitions and units
- notation/convention cross-check
- previously frozen benchmark

If the check fails, **report the failure before changing the model story**.

### 8. Report results using `renorm:core` tagging

Every status update separates `Derived` / `Assumed` / `Phenomenological` / `Exploratory` per the core's vocabulary. Do not present exploratory numerics as established physics.

## Red Flags

Stop if any of these appear:

- "We can just put this in by hand for now" without labeling it `Phenomenological`.
- "The band looks reasonable" without an occupancy or symmetry check.
- "This should be the same as before" without a representation or notation comparison.
- "The numerical result suggests..." before stating what exact equation it came from.
- "I know what this variable means" without writing its definition in the current notation.
- "Let me just code it first" before the derivation ledger exists.
- Multiple new approximations introduced in a single step (split it).

## Minimal Communication Contract

Before any new theory code or claim, say:

1. what is derived
2. what is assumed
3. what is being fit or put in by hand
4. what exact script or benchmark will check it

If these four items are not stated, the step is not ready.

## Activation via slash command

If the user explicitly invokes `/derive [goal]`, start a fresh ledger immediately:
- with the supplied goal as the **observable target** if an argument is given,
- otherwise prompt for the target before proceeding.
