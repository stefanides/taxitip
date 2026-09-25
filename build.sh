#!/usr/bin/env bash
# Build script — spojí _header.html + obsah + _footer.html
# Použití: ./build.sh
# Výsledek: public/index.html a public/night-club.html

set -euo pipefail

SRC="src"
OUT="public"
HEADER="$SRC/_header.html"
FOOTER="$SRC/_footer.html"

build_page() {
  local src_file="$1"     # např. src/index.html
  local out_file="$2"     # např. public/index.html
  local page_title meta_desc header_out

  # Přečíst metadata z komentářů v souboru
  page_title=$(grep -m1 'PAGE_TITLE:' "$src_file" | sed 's/.*PAGE_TITLE: //' | sed 's/ -->//' | xargs)
  meta_desc=$(grep -m1 'META_DESCRIPTION:' "$src_file" | sed 's/.*META_DESCRIPTION: //' | sed 's/ -->//' | xargs)

  # Nahradit placeholdery v headeru
  header_out=$(sed \
    -e "s|{{PAGE_TITLE}}|${page_title}|g" \
    -e "s|{{META_DESCRIPTION}}|${meta_desc}|g" \
    "$HEADER")

  # Sestavit výsledný soubor
  {
    echo "$header_out"
    cat "$src_file"
    cat "$FOOTER"
  } > "$out_file"

  echo "  ✓  $out_file"
}

echo "Taxi Tip Ostrava — build"
echo "------------------------"
build_page "$SRC/index.html"      "$OUT/index.html"
build_page "$SRC/night-club.html" "$OUT/night-club.html"
echo "Hotovo."
