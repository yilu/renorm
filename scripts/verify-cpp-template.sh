#!/usr/bin/env bash
set -euo pipefail

TEMPLATE="$(pwd)/skills/init-package/templates/cpp"
TMP="$(mktemp -d)/test_pkg"
PKG="test_pkg"

cp -R "$TEMPLATE" "$TMP"

# Rename __pkg__ directories and __pkg__.* files.
# Only substitute in the basename — substituting in the full path would
# break depth-first nested renames (parent dir renamed before children walked).
find "$TMP" -depth -name '__pkg__*' | while read f; do
    newbase=$(basename "$f" | sed "s/__pkg__/$PKG/g")
    newname="$(dirname "$f")/$newbase"
    mv "$f" "$newname"
done

# Substitute placeholders in remaining file content
find "$TMP" -type f \( -name 'CMakeLists.txt' -o -name '*.cpp' -o -name '*.h' -o -name '*.md' \) -exec \
    sed -i '' \
        -e "s/{{PACKAGE_NAME}}/$PKG/g" \
        {} +

# Configure with CMake (does not actually build)
BUILD="$(mktemp -d)"
cmake -B "$BUILD" -S "$TMP" >/dev/null

# Verify expected files exist
test -f "$TMP/CMakeLists.txt"
test -f "$TMP/include/$PKG/$PKG.h"
test -f "$TMP/src/$PKG.cpp"
test -f "$TMP/tests/test_main.cpp"

echo "C++ template OK: $TMP"
