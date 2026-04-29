#!/usr/bin/env bash
set -euo pipefail

TEMPLATE="$(pwd)/skills/init-package/templates/python"
TMP="$(mktemp -d)/test_pkg"
PKG="test_pkg"

# Copy template
cp -R "$TEMPLATE" "$TMP"

# Rename __pkg__ → test_pkg
find "$TMP" -depth -name '__pkg__' -execdir mv {} "$PKG" \;

# Substitute placeholders (macOS sed needs '' after -i)
find "$TMP" -type f \( -name '*.py' -o -name '*.toml' -o -name '*.md' \) -exec \
    sed -i '' \
        -e "s/{{PACKAGE_NAME}}/$PKG/g" \
        -e "s/{{AUTHOR_NAME}}/Test Author/g" \
        -e "s/{{AUTHOR_EMAIL}}/test@example.com/g" \
        {} +

# Validate pyproject.toml is valid TOML
python3 -c "import tomllib; tomllib.loads(open('$TMP/pyproject.toml').read())"

# Validate Python files parse
python3 -m py_compile "$TMP/src/$PKG/__init__.py"
python3 -m py_compile "$TMP/src/$PKG/core.py"
python3 -m py_compile "$TMP/tests/test_core.py"

echo "Python template OK: $TMP"
