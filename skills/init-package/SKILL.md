---
name: init-package
description: "Use when initializing a new scientific computing package in Python, Julia, or C++. Picks the appropriate template directory based on user's request. Generates a working package skeleton with reproducibility conventions (RNG seeding, units in comments, type hints) consistent with the user's rules in ~/.claude/rules/."
---

# renorm:init-package — Scientific Package Scaffolding

Generate a new scientific computing package in Python, Julia, or C++ from bundled templates.

## Workflow

1. **Identify language and package name.**
   - If the user said "Python package called my_pkg", language is `python`, name is `my_pkg`.
   - If the user said "Julia package MyPkg", language is `julia`, name is `MyPkg` (PascalCase).
   - If only one is unclear, ask. Do not guess.

2. **Identify target directory.**
   - Default: a new subdirectory in the current working directory named after the package.
   - User may override with an explicit path.

3. **Locate the template directory.**
   - For Python: `<this-skill>/templates/python/`
   - For Julia: `<this-skill>/templates/julia/`
   - For C++: `<this-skill>/templates/cpp/`

4. **Recursively copy templates to the target directory, applying:**

   **File content substitutions** (in every file, including filenames):
   - `{{PACKAGE_NAME}}` → user's package name (snake_case for Python/C++, PascalCase for Julia)
   - `{{PACKAGE_NAME_PASCAL}}` → user's package name in PascalCase (Julia uses this for the module file)
   - `{{AUTHOR_NAME}}` → from `git config user.name`
   - `{{AUTHOR_EMAIL}}` → from `git config user.email`
   - `{{YEAR}}` → current year
   - `{{DATE}}` → current date (YYYY-MM-DD)

   **Directory renames:**
   - `__pkg__` → user's package name (snake_case)
   - `__PkgPascal__` → user's package name (PascalCase)

5. **Verify the result is well-formed:**
   - Python: `pyproject.toml` parses as TOML.
   - Julia: `Project.toml` parses as TOML.
   - C++: `CMakeLists.txt` is present.

6. **Report what was created**, with the exact files and a one-line summary per file.

7. **Do not initialize git, install dependencies, or run tests automatically.** Tell the user the next steps:
   - Python: `cd <pkg> && pip install -e ".[dev]"`
   - Julia: `cd <pkg> && julia --project=. -e 'using Pkg; Pkg.instantiate()'`
   - C++: `cd <pkg> && cmake -B build -S . && cmake --build build`

## Conventions

The generated packages follow the user's existing scientific-computing rules at `~/.claude/rules/{python,julia,cpp}.md`:

- Random number generation is seeded for reproducibility.
- Units are documented in comments (e.g., `# Kelvin`, `# eV`).
- Functions have type hints / annotations.
- Tests are scaffolded (pytest for Python, Test stdlib for Julia, simple CMake test for C++).

The skill body does not restate these conventions because they're already in the user's rules and loaded into context via `~/.claude/CLAUDE.md`.

## When this skill should NOT fire

- The user already has a package and wants to add a feature → just edit existing code.
- The user wants a different language (Rust, Fortran, Lua) → say so and offer to add a template directory.
- The user wants a non-scientific Python project (web app, CLI tool) → this skill is opinionated for scientific computing and may not fit.
