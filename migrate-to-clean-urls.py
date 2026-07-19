"""
Convert every internal link, canonical, og:url, and JSON-LD URL in the
RequiredFilings site from `page.html` form to clean `page` form.
Also updates sitemap.xml.

What it changes (only INSIDE required-filings/):

  1. `href="page.html"`           -> `href="page"`
     `href="page.html#anchor"`    -> `href="page#anchor"`
     `href="index.html"`          -> `href="/"`  (special-cased home)
     `href="index.html#anchor"`   -> `href="/#anchor"`

  2. `<link rel="canonical" href="https://requiredfilings.com/page.html" />`
     -> `... /page" />`

  3. `<meta property="og:url" content=".../page.html" />`
     -> `... /page" />`

  4. JSON-LD (inside <script type="application/ld+json">):
     Any `"url":"https://requiredfilings.com/page.html"` and
     `"item":"https://requiredfilings.com/page.html"` -> stripped.

  5. sitemap.xml: `<loc>https://requiredfilings.com/page.html</loc>` -> stripped.

Skips:
  - External URLs (https:, http:, mailto:, tel:, javascript:)
  - Anchor-only links (href="#foo")
  - Asset paths (`assets/css/main.css`, `assets/js/…`, images) — those aren't
    .html so the regex won't touch them anyway.
  - The literal string "404.html" — leave 404 handling to Apache ErrorDocument.

Reads and writes UTF-8 without BOM per project rules.
Idempotent.
"""
from pathlib import Path
import re
import sys, io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

ROOT = Path(r"d:/Website Projects/Required Filings Website/required-filings")

# ────────────────────────────────────────────────────────────────
# HTML regexes
# ────────────────────────────────────────────────────────────────

# Match href="something.html" or href='something.html' (with optional #anchor / ?query),
# where "something" is a bare filename or relative path — NOT starting with a scheme.
# We also don't want to touch href="#..." (anchor-only) or href="//..." (protocol-relative).
_HREF_HTML = re.compile(
    r'''(href\s*=\s*["'])'''             # 1: attribute up to opening quote
    r'''(?!https?://|mailto:|tel:|javascript:|//|\#)'''  # skip external / anchor
    r'''([^"'#?]*?)\.html'''             # 2: path without extension
    r'''([#?][^"']*)?'''                 # 3: optional #anchor or ?query
    r'''(["'])''',                       # 4: closing quote
    re.IGNORECASE,
)

# Special case: href to index (root/home) — collapse to "/"
_HREF_INDEX = re.compile(
    r'''(href\s*=\s*["'])'''
    r'''(?:\./)?index'''                 # optional "./" prefix, then "index"
    r'''([#?][^"']*)?'''
    r'''(["'])''',
    re.IGNORECASE,
)

# Canonical + og:url meta rewrites — full absolute URLs
_CANONICAL = re.compile(
    r'''(<link\s+rel=["']canonical["']\s+href=["'])'''
    r'''(https?://[^"']+?)\.html'''
    r'''(["'][^>]*/?>)''',
    re.IGNORECASE,
)
_OG_URL = re.compile(
    r'''(<meta\s+property=["']og:url["']\s+content=["'])'''
    r'''(https?://[^"']+?)\.html'''
    r'''(["'][^>]*/?>)''',
    re.IGNORECASE,
)

# JSON-LD URLs — only strip .html when it's a value in JSON.
# Pattern: "url":"https://requiredfilings.com/page.html"
# Pattern: "item":"https://requiredfilings.com/page.html"
_JSONLD_URL = re.compile(
    r'''("(?:url|item|@id|mainEntityOfPage)"\s*:\s*")'''
    r'''(https?://[^"]+?)\.html'''
    r'''(")''',
)

# ────────────────────────────────────────────────────────────────
# Sitemap regex
# ────────────────────────────────────────────────────────────────
_SITEMAP_LOC = re.compile(
    r'''(<loc>)(https?://[^<]+?)\.html(</loc>)''',
    re.IGNORECASE,
)

# ────────────────────────────────────────────────────────────────
# Helpers
# ────────────────────────────────────────────────────────────────

def _href_replace(m):
    prefix, path, tail, quote = m.group(1), m.group(2), m.group(3) or '', m.group(4)
    # Special: page name is "index" or ends with "/index" — collapse to root
    if path == 'index' or path.endswith('/index'):
        base = '/' if path == 'index' else path[:-len('index')]  # e.g. "foo/index" -> "foo/"
        return f'{prefix}{base}{tail}{quote}'
    return f'{prefix}{path}{tail}{quote}'

def process_html(path: Path) -> bool:
    raw = path.read_text(encoding='utf-8')
    new = raw

    # 1. All internal href="page.html" strips (also handles page.html#anchor)
    new = _HREF_HTML.sub(_href_replace, new)

    # 2. Canonical
    new = _CANONICAL.sub(r'\1\2\3', new)

    # 3. og:url
    new = _OG_URL.sub(r'\1\2\3', new)

    # 4. JSON-LD urls / items
    new = _JSONLD_URL.sub(r'\1\2\3', new)

    if new != raw:
        # Preserve UTF-8 without BOM
        path.write_bytes(new.encode('utf-8'))
        return True
    return False


def process_sitemap(path: Path) -> bool:
    raw = path.read_text(encoding='utf-8')
    new = _SITEMAP_LOC.sub(r'\1\2\3', raw)
    if new != raw:
        path.write_bytes(new.encode('utf-8'))
        return True
    return False


# ────────────────────────────────────────────────────────────────
# Run
# ────────────────────────────────────────────────────────────────

changed_html = 0
for html in sorted(ROOT.glob("*.html")):
    if process_html(html):
        changed_html += 1
        print(f"  updated: {html.name}")
    else:
        print(f"  no change: {html.name}")

print()
sitemap = ROOT / "sitemap.xml"
if sitemap.exists() and process_sitemap(sitemap):
    print(f"  updated: sitemap.xml")
else:
    print(f"  no change: sitemap.xml")

print(f"\nDone. {changed_html} of {len(list(ROOT.glob('*.html')))} HTML files updated.")
