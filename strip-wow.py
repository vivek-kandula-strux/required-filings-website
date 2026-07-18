"""
Strip WOW.js and animate.css from all 20 flat HTML pages.
Reads / writes UTF-8 without BOM per project rules.
Leaves `class="wow …"` residue in place (harmless; CSS safety net covers it).
Idempotent.
"""
from pathlib import Path
import re

ROOT = Path(r"d:/Website Projects/Required Filings Website/required-filings")

# Two consecutive patterns matched:
# 1) <link rel="stylesheet" href="assets/css/animate.css">
# 2) <script src="assets/js/wow.min.js"></script>
# Plus surrounding "<!-- Animate.css >>" or "<!-- Wow.min.js >>" comment on same or preceding line.

removals = [
    # Animate.css <link> — allow optional preceding template comment on same or previous line
    (re.compile(r'\s*<!--\s*<<\s*Animate(\.css)?\s*>>\s*-->\s*\n\s*<link[^>]+animate\.css[^>]*>\s*\n', re.IGNORECASE), '\n'),
    (re.compile(r'\s*<link[^>]+animate\.css[^>]*>\s*\n', re.IGNORECASE), '\n'),
    # wow.min.js <script>
    (re.compile(r'\s*<!--\s*<<\s*Wow(\.min\.js)?\s*>>\s*-->\s*\n\s*<script[^>]+wow\.min\.js[^>]*>\s*</script>\s*\n', re.IGNORECASE), '\n'),
    (re.compile(r'\s*<script[^>]+wow\.min\.js[^>]*>\s*</script>\s*\n', re.IGNORECASE), '\n'),
]

changed = 0
for html in sorted(ROOT.glob("*.html")):
    raw = html.read_text(encoding="utf-8")
    new = raw
    for pat, sub in removals:
        new = pat.sub(sub, new)
    if new != raw:
        html.write_text(new, encoding="utf-8", newline="")
        changed += 1
        print(f"stripped: {html.name}")
    else:
        print(f"unchanged: {html.name}")
print(f"\n{changed} of {len(list(ROOT.glob('*.html')))} files updated.")
