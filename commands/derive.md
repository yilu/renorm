---
description: "Force-invoke renorm:derivation to start a derivation ledger. Optional argument: the observable target."
---

# /derive — start a derivation ledger

Use the **renorm:derivation** skill to apply derivation-ledger discipline.

If an argument was provided after `/derive`, treat it as the **observable target** and begin filling the ledger immediately:

```
- Observable target: <user argument>
- Primary variables / objects: ...
- Held fixed / neglected / integrated out: ...
- Starting equations: ...
- Approximation level: ...
- Falsification check: ...
```

If no argument was given, ask: "What is the observable target you're computing?" and refuse to proceed until the user answers.

In either case, follow `renorm:derivation`'s workflow strictly: one new approximation layer per step, falsification check before trusting any result, no theory code before the ledger exists. Tagging vocabulary follows `renorm:core`.
