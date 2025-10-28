#!/bin/bash

# 🌊⚡ LOWERCASE AESTHETIC TRANSFORMATION
# Rename all uppercase files in grainstore to lowercase

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         🌊⚡ LOWERCASE AESTHETIC TRANSFORMATION 🌊⚡          ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "bringing visual calm to the grainstore..."
echo ""

cd /home/xy/kae3g/grainkae3g

# Find and rename README.md files
find grainstore -type f -name "README.md" \
  -not -path "*/urbit-source/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/.dfx/*" \
  -exec bash -c 'dir=$(dirname "$1"); mv "$1" "$dir/readme.md" 2>/dev/null || true' _ {} \;

# Find and rename other uppercase MD files
find grainstore -type f -name "*.md" \
  -not -path "*/urbit-source/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/.dfx/*" \
  -exec bash -c '
    file="$1"
    dir=$(dirname "$file")
    base=$(basename "$file")
    lower=$(echo "$base" | tr "[:upper:]" "[:lower:]")
    if [ "$base" != "$lower" ]; then
      echo "Renaming: $file → $dir/$lower"
      mv "$file" "$dir/$lower" 2>/dev/null || true
    fi
  ' _ {} \;

echo ""
echo "✨ transformation complete! all files now flow in lowercase harmony."
echo ""


