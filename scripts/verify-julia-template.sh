#!/usr/bin/env bash
set -euo pipefail

TEMPLATE="$(pwd)/skills/init-package/templates/julia"
TMP="$(mktemp -d)/TestPkg"
PKG="TestPkg"

cp -R "$TEMPLATE" "$TMP"

# Rename __PkgPascal__.jl → TestPkg.jl
find "$TMP" -depth -name '__PkgPascal__*' | while read f; do
    newname=$(echo "$f" | sed "s/__PkgPascal__/$PKG/g")
    mv "$f" "$newname"
done

# Substitute placeholders
find "$TMP" -type f \( -name '*.jl' -o -name '*.toml' -o -name '*.md' \) -exec \
    sed -i '' \
        -e "s/{{PACKAGE_NAME_PASCAL}}/$PKG/g" \
        -e "s/{{AUTHOR_NAME}}/Test Author/g" \
        -e "s/{{AUTHOR_EMAIL}}/test@example.com/g" \
        {} +

# Validate Project.toml is valid TOML
python3 -c "import tomllib; tomllib.loads(open('$TMP/Project.toml').read())"

# Verify the module file exists with the right name
test -f "$TMP/src/$PKG.jl" || { echo "FAIL: $TMP/src/$PKG.jl missing"; exit 1; }
test -f "$TMP/test/runtests.jl" || { echo "FAIL: runtests.jl missing"; exit 1; }

echo "Julia template OK: $TMP"
