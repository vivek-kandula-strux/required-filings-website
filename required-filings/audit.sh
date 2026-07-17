#!/bin/bash

echo "STRUCTURAL HTML AUDIT REPORT"
echo "============================"
echo ""

# Issue 1: Button or input inside anchor
echo "1. BUTTON/INPUT INSIDE ANCHOR TAG:"
count=0
for file in *.html; do
  if grep -q '<a[^>]*>.*<\(button\|input\)' "$file" 2>/dev/null; then
    echo "  $file: FOUND"
    ((count++))
  fi
done
if [ $count -eq 0 ]; then echo "  No issues found"; fi
echo ""

# Issue 2: Empty headings
echo "2. EMPTY HEADINGS:"
count=0
for file in *.html; do
  if grep -qE '<h[1-6]\s*>[\s]*</h[1-6]>' "$file"; then
    echo "  $file: FOUND"
    grep -n '<h[1-6]\s*>[\s]*</h[1-6]>' "$file" | head -2
    ((count++))
  fi
done
if [ $count -eq 0 ]; then echo "  No issues found"; fi
echo ""

# Issue 3: Missing lang attribute
echo "3. MISSING LANG ATTRIBUTE:"
count=0
for file in *.html; do
  if ! grep -q '<html[^>]*lang=' "$file"; then
    echo "  $file: MISSING"
    ((count++))
  fi
done
if [ $count -eq 0 ]; then echo "  All files have lang attribute"; fi
echo ""

# Issue 4: Multiple H1 per page
echo "4. MULTIPLE H1 PER PAGE:"
count=0
for file in *.html; do
  h1_count=$(grep -c '<h1' "$file" 2>/dev/null || echo 0)
  if [ "$h1_count" -gt 1 ]; then
    echo "  $file: $h1_count H1 tags"
    ((count++))
  fi
done
if [ $count -eq 0 ]; then echo "  No multiple H1s found"; fi
echo ""

# Issue 5: javascript:void(0) anchors
echo "5. ANCHOR WITH href=\"javascript:void(0)\" (Count per file):"
for file in *.html; do
  count=$(grep -c 'href="javascript:void(0)"' "$file" 2>/dev/null || echo 0)
  if [ "$count" -gt 0 ]; then
    echo "  $file: $count occurrences"
  fi
done
echo ""

# Issue 6: Select with no label
echo "6. SELECT WITHOUT LABEL OR ARIA-LABEL:"
for file in *.html; do
  if grep -q '<select' "$file"; then
    select_ids=$(grep -o 'id="[^"]*"' "$file" | grep -o '[^"]*' | tail -1)
    select_count=$(grep -c '<select' "$file" 2>/dev/null || echo 0)
    label_count=$(grep -c '<label' "$file" 2>/dev/null || echo 0)
    if [ "$label_count" -eq 0 ] && [ "$select_count" -gt 0 ]; then
      echo "  $file: $select_count select(s), NO ASSOCIATED LABELS"
    fi
  fi
done

