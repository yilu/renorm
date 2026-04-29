# renorm — design spec

**Date:** 2026-04-29
**Author:** Yi Lu (`yilu`)
**Repo:** `github.com/yilu/renorm` (planned)
**Local path:** `~/Documents/Work/codes/renorm/`

## Name

**renorm** — *Research Epistemics: Note, Observe, Reference, Model.*

The physics word ("renormalization") carries the metaphor: bare claims (Claude's first-draft assertions) get dressed by grounding, citation, and tagging until they become trustworthy claims, the way bare quantities in QFT get dressed by interactions until they become physically measurable.

## Purpose

A self-contained Claude Code plugin that fixes a recurring failure mode in research conversations with Claude: hand-waving, unfounded claims, and ungrounded suggestions. Imposes epistemic discipline (claim tagging + literature grounding) by default, with structured wrappers for derivation work and paper analysis. Bundles existing language scaffolding skills so a single `/plugin install` covers the user's full Claude-side toolkit.

## Scope

**In scope:**

- A core skill enforcing claim tagging + grounding discipline on research-level theoretical-physics conversations.
- A derivation wrapper porting an existing Codex-side skill (`derivation-first-modeling`), slimmed and re-aligned to the core's tagging vocabulary.
- A paper-analysis wrapper enforcing quote-before-claim discipline.
- A consolidated `init-package` skill (Python / Julia / C++) replacing three existing per-language skills, using bundled templates instead of embedded code blocks.
- Three slash commands as deterministic fallbacks when auto-triggers don't fire: `/renorm`, `/derive`, `/paper`.

**Out of scope (for v0.1–v0.3):**

- Agents, hooks, tests directories.
- CI / GitHub Actions.
- Marketplace registration.
- Discussion-mode wrapper (handled by core).
- Inspiration-mode wrapper (handled by core).
- Per-language slash commands for `init-package` (auto-trigger is sufficient).

**Explicitly deferred:**

- Trigger-language refinement (after dogfooding).
- Auto-escalation of grounding to Zotero/WebSearch without user prompt.
- Additional template languages beyond Python / Julia / C++.

## Architecture

### Repo layout

```
renorm/
├── .claude-plugin/
│   ├── plugin.json                 # plugin manifest
│   └── marketplace.json            # single-plugin marketplace registration
├── README.md
├── CHANGELOG.md
├── LICENSE                         # MIT
├── docs/
│   └── superpowers/
│       └── specs/
│           └── 2026-04-29-renorm-design.md
├── skills/
│   ├── core/
│   │   └── SKILL.md                # → renorm:core
│   ├── derivation/
│   │   └── SKILL.md                # → renorm:derivation
│   ├── paper-analysis/
│   │   └── SKILL.md                # → renorm:paper-analysis
│   └── init-package/
│       ├── SKILL.md                # → renorm:init-package
│       └── templates/
│           ├── python/
│           ├── julia/
│           └── cpp/
└── commands/
    ├── renorm.md                   # /renorm <claim>
    ├── derive.md                   # /derive
    └── paper.md                    # /paper <ref>
```

### Plugin shape choice

- Auto-triggers (via SKILL.md `description`) plus explicit slash commands as fallback.
- No `agents/`, `hooks/`, or `tests/` in v0.1.
- Plugin manifest is `.claude-plugin/plugin.json`, matching the convention of installed plugins on this machine (verified against `superpowers`, `frontend-design`, `codex`).
- The repo also serves as a single-plugin marketplace via `.claude-plugin/marketplace.json` so users can install with `/plugin marketplace add yilu/renorm` followed by `/plugin install renorm@renorm`. Without `marketplace.json`, only the `--plugin-dir` development path works.

### Skill namespacing

Folder names stay short (`core`, `derivation`, `paper-analysis`, `init-package`) because Claude Code prefixes them with the plugin name. They surface as `renorm:core`, etc.

## Components

### `renorm:core` — claim discipline

**Trigger prose (draft, subject to revision after dogfooding):**

> Use when the user is making, asking about, or evaluating a research-level theoretical physics claim or comparison — about a specific system, mechanism, methodology, recent result, or unexplored regime. Applies to correlated systems, condensed matter, many-body physics, and adjacent topics. Skip for textbook recall (e.g., "what is BCS pairing"), code/tooling, casual conversation, or algebra inside an active derivation.

**Two disciplines, both fire when the trigger fires:**

1. **Tagging contract.** Every substantive claim is tagged:
   - `Derived` — follows from explicit equations/derivation visible in this conversation.
   - `Assumed` — explicit assumption being made for the discussion.
   - `Phenomenological` — fitted/empirical input, not derived.
   - `Exploratory` — speculative, not grounded.
   - `Training-knowledge` — Claude's recall, not verified, possibly stale.

2. **Grounding contract** (d-mode, hybrid):
   - Default: state understanding from training knowledge, tagged `Training-knowledge`. Identify what's known, what's been tried, what's adjacent.
   - Escalation (when user asks "verify" or stakes are high):
     1. Zotero MCP first (curated library, fulltext, user annotations).
     2. WebSearch / arXiv lookup only if Zotero comes up empty.
   - No external skill imports. Borrowed content is copied with attribution if the borrowed text is substantive.

### `renorm:derivation` — derivation ledger

**Trigger prose:**

> Use when actively performing a theoretical derivation — including exploratory expansions and back-of-envelope estimates: writing equations, applying approximations (perturbation, mean-field, saddle-point, downfolding), expanding to a given order, computing a spectrum or response. Ledger weight scales with derivation complexity — short exploratory derivations get a lightweight ledger; full derivations get the 6-field form. Not for discussing existing derivations from a paper (use renorm:paper-analysis) or pure conceptual comparison (use renorm:core).

**Ledger structure (6 fields, slimmed from existing 10-field prototype):**

1. Observable target.
2. Primary variables / objects.
3. Held fixed / neglected / integrated out.
4. Starting equations.
5. Approximation level (one new layer per step).
6. Falsification check.

**Lightweight mode for exploratory work:** 3-line collapsed form ("expanding around X; keeping Y; neglecting Z"). Heavy 6-field form only for derivations intended to produce trustworthy results.

**Tagging vocabulary** is referenced from `renorm:core`, not duplicated.

**Source:** Port of `~/.codex/skills/derivation-first-modeling/SKILL.md` (5.4 KB). Original stays in place — Codex still uses it via the user's CCB workflow. The renorm version is the Claude-side equivalent.

### `renorm:paper-analysis` — paper reading discipline

**Trigger prose:**

> Use when summarizing, analyzing, or extending claims from a specific paper (arXiv ID, DOI, or local PDF). Not for general "what does field X say" questions, which go to renorm:core.

**Discipline:**

- **Three-bucket reporting** for every output:
  - `Paper-claim` — direct quote, equation reference (`Eq. 12`), or figure reference (`Fig. 3, the χ=400 curve`).
  - `Inference` — Claude's own derivation from what the paper said.
  - `Connection` — context Claude is bringing in from elsewhere.
- **Mandatory assumptions line** for every result quoted: "depends on lattice / approximation / symmetry / parameter regime / numerical method."
- **Don't extend silently.** If the user asks about a regime / lattice / limit the paper doesn't cover, the gap must be named before speculating.
- Tagging vocabulary referenced from `renorm:core` for non-paper claims.

### `renorm:init-package` — scientific package scaffolding

**Trigger prose:**

> Use when initializing a new scientific computing package in Python, Julia, or C++. Picks the appropriate template directory based on the user's request.

**Migration:** Replaces the three existing skills (`init-python-package`, `init-julia-package`, `init-cpp-package`) at `~/.claude/skills/`. Conventions (units in comments, RNG seeds, type hints) continue to live in `~/.claude/rules/{python,julia,cpp}.md` — the skill itself doesn't restate them.

**Layout:**

- `SKILL.md` — workflow + dispatch by language argument.
- `templates/python/` — `pyproject.toml`, `__init__.py`, `tests/test_core.py`, `.gitignore`, `README.md`, etc.
- `templates/julia/` — `Project.toml`, `src/PackageName.jl`, `test/runtests.jl`, etc.
- `templates/cpp/` — `CMakeLists.txt`, `include/`, `src/`, etc.

Templates are real files, not embedded code blocks, so they can be linted, diff-tracked, and extended by adding directories without touching SKILL.md.

### Slash commands

- **`/renorm <claim>`** — force-invokes `renorm:core`. Optional argument: a specific claim to interrogate (tagged + grounded immediately). No argument: applies discipline to the next exchange.
- **`/derive`** — force-invokes `renorm:derivation`, starts a fresh ledger.
- **`/paper <ref>`** — force-invokes `renorm:paper-analysis` with arXiv ID, DOI, or local PDF path.

Each command file is thin (under 20 lines): a directive to invoke the corresponding skill, with argument passthrough. The discipline lives in the skills.

### Composition (not strict co-firing)

The three discipline skills compose by reference rather than firing together. The trigger boundaries are mutually informative:

- `core` fires on research-level physics conversations *outside* active derivation or paper analysis. Its description explicitly excludes "algebra inside an active derivation."
- `derivation` fires on active derivation work; its SKILL.md references `core`'s tagging vocabulary, so claims made during derivation are still tagged.
- `paper-analysis` fires when a specific paper is the subject; same pattern — references `core`'s tagging for any non-paper claims that arise.

The wrappers do not depend on `core` firing in parallel. They incorporate the tagging discipline by reference, so the user gets full discipline regardless of which skill activates. This avoids overlapping triggers (which can confuse Claude Code's skill selection) while preserving the unified vocabulary.

## Data flow

### When `renorm:core` fires (tagging + grounding)

```
user query
   ↓
[trigger matches research-level physics claim/comparison]
   ↓
Claude composes response
   ↓
[before output] every substantive claim gets tagged
   ↓
[if grounding required] training-knowledge presented first, tagged
   ↓
[if user asks to verify] Zotero MCP → WebSearch → arXiv
   ↓
output with tagged + grounded claims
```

### When `renorm:derivation` fires (ledger)

```
user query (derivation request)
   ↓
[skill fires]
   ↓
Claude writes ledger (3-line lightweight or 6-field heavy)
   ↓
Claude executes one approximation layer
   ↓
falsification check
   ↓
output with ledger + result, tagged via core
```

### When `renorm:paper-analysis` fires (three-bucket)

```
user query naming a specific paper
   ↓
[skill fires]
   ↓
Claude reads paper (or uses Zotero/WebFetch)
   ↓
output structured as Paper-claim / Inference / Connection
   ↓
assumptions line + gap-naming if extending beyond paper
```

## Error handling and edge cases

- **Trigger over-fires** (skill activates on casual conversation): expected during dogfood; refine `description` prose. Not a runtime failure.
- **Trigger under-fires** (skill silently doesn't activate): user invokes via `/renorm`, `/derive`, or `/paper`. The slash commands exist precisely as fallback.
- **Grounding escalation tools unavailable** (Zotero MCP not running, WebSearch fails): degrade to training-knowledge with explicit `Training-knowledge` tag. Never silently pretend grounding happened.
- **Wrapper fires without core** (e.g., `derivation` triggers but `core` doesn't): wrappers reference `core`'s tagging vocabulary in their SKILL.md, so the discipline is still applied even if `core`'s description didn't trigger separately.
- **Co-firing conflicts:** none expected by design; if observed, refine triggers to clarify ownership of the case.

## Testing

Dogfooding only for v0.1.

- After install, use the plugin in normal research conversations for ~1 week.
- Track: where did the skill auto-fire when it shouldn't? Where did it fail to auto-fire when it should?
- Adjust `description` prose accordingly. Treat trigger language as *living* until stable.

No automated test suite in v0.1. Skills are prose contracts; their correctness is judged by the conversations they shape, not by test runs. CI and tests can be added later if needed.

## MVP staging

### v0.1 — core + init-package (option A locked)

**Ships:**

- `renorm:core` (full discipline spec).
- `renorm:init-package` (migrated from three existing skills, restructured to one skill + `templates/{python,julia,cpp}/`).
- `/renorm` slash command.
- Repo bootstrap: `package.json`, `README.md`, `LICENSE` (MIT), `CHANGELOG.md`.

**Acceptance criteria:**

- Repo installs cleanly via `/plugin install <github-url>` on a fresh machine.
- `/renorm` fires and applies tagging + grounding to the next claim.
- `renorm:core` auto-triggers in real research-level discussions, verified by 1 week of dogfooding.
- `renorm:init-package` generates valid Python / Julia / C++ scaffolds matching existing conventions.

**Then dogfood for ~1 week** before adding anything.

### v0.2 — derivation wrapper

**Ships:**

- `renorm:derivation` ported from `~/.codex/skills/derivation-first-modeling`, slimmed to the 6-field ledger, referencing `renorm:core`'s tagging vocabulary.
- `/derive` slash command.

**Acceptance:** when actively deriving, the ledger is honored. Lightweight 3-line form for exploratory work, full 6-field form for serious derivations.

The Codex-side `derivation-first-modeling` stays in place. Two homes for the same discipline, one per agent.

### v0.3 — paper-analysis wrapper

**Ships:**

- `renorm:paper-analysis` (new skill).
- `/paper <ref>` slash command.

**Acceptance:** fires on arXiv ID / DOI / local PDF input; quote-before-claim discipline observable in outputs.

### Beyond v0.3 (deferred, not promised)

- Trigger-language refinement based on dogfooding (open-ended).
- Additional `init-package` template languages (Rust, Lua, Fortran) — just add a directory.
- Auto-escalation of grounding without explicit user prompt.

## Attribution policy

| Source | Treatment |
|---|---|
| `~/.codex/skills/derivation-first-modeling` (own work) | README note that `renorm:derivation` is a port. No formal attribution required. |
| `yy/claude-scholar` (MIT) | Attribution required *only if substantive text is copied*. If we rewrite the same idea from scratch, no attribution needed. Decision deferred to port time. |
| `Imbad0202/academic-research-skills`, `Psypeal/claude-knowledge-vault` | Pure idea inspiration. No attribution required. Optional "see also" mention. |

Standing rule: **no runtime dependencies on external skills.** Anything we want gets ported into a `renorm` skill file.

## License

MIT.

## Open items (carried into the implementation plan)

- Plugin manifest fields verified: `name`, `version`, `description`, `author`, `homepage`, `repository`, `license`, `keywords`. Located at `.claude-plugin/plugin.json`.
- Precise `description` field length tolerated by Claude Code's skill loader (the trigger drafts above are ~50–80 words; verify these don't get truncated).
- Whether `/renorm <claim>` argument is passed to the skill via stdin, environment, or in-prompt — confirm command-format conventions.
- Whether `templates/` directory under `init-package/` is bundled into the install or fetched on demand (matters for offline use).
- Migration of existing `~/.claude/skills/init-{python,julia,cpp}-package/` after v0.1 ships: keep, retire, or symlink to plugin?
