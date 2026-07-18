"""
Trim Font Awesome to only weights actually used on the site.

Site usage (from audit, 20 HTML pages):
  fa-solid    x 497  (KEEP)
  fa-regular  x 41   (KEEP)
  fa-brands   x 1    (KEEP - fa-whatsapp)
  fa-sharp    x 1    (KEEP - one usage, might reference solid too)
  fa-light    x 0    (REMOVE)
  fa-thin     x 0    (REMOVE)
  fa-duotone  x 0    (REMOVE)

Actions:
  1. Rewrite all.min.css: drop @font-face blocks for fa-light, fa-thin,
     fa-duotone, fa-v4compatibility. Strip .ttf format() clauses from remaining
     blocks (browsers use .woff2; .ttf is dead weight).
  2. Delete assets/webfonts/*.ttf (all six + v4compat = 5.9 MB — never fetched).
  3. Delete unused .woff2 files: fa-light-300, fa-thin-100, fa-duotone-900,
     fa-v4compatibility (~1.2 MB).
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent / "required-filings"
CSS = ROOT / "assets" / "css" / "all.min.css"
FONTS = ROOT / "assets" / "webfonts"

UNUSED_STEMS = (
    "fa-light-300",
    "fa-thin-100",
    "fa-duotone-900",
    "fa-v4compatibility",
)


def rewrite_css() -> None:
    original = CSS.read_text(encoding="utf-8")
    css = original
    face_pattern = re.compile(r"@font-face\{[^{}]*\}")

    # Drop @font-face blocks that reference any unused stem
    def keep(match: re.Match) -> str:
        block = match.group(0)
        for stem in UNUSED_STEMS:
            if stem in block:
                return ""
        return block

    css = face_pattern.sub(keep, css)

    # Strip .ttf fallback from remaining blocks (browsers prefer woff2)
    # Pattern: ,url(../webfonts/xxx.ttf) format("truetype")
    css = re.sub(
        r',\s*url\([^)]+\.ttf\)\s*format\("truetype"\)',
        "",
        css,
    )

    before = len(original)
    after = len(css)
    saved = before - after
    CSS.write_text(css, encoding="utf-8")
    print(f"  all.min.css: {before:,} -> {after:,} bytes ({saved:,} saved)")


def delete_ttf() -> int:
    freed = 0
    for ttf in FONTS.glob("*.ttf"):
        freed += ttf.stat().st_size
        ttf.unlink()
        print(f"  deleted {ttf.name}")
    return freed


def delete_unused_woff2() -> int:
    freed = 0
    for stem in UNUSED_STEMS:
        w = FONTS / f"{stem}.woff2"
        if w.exists():
            freed += w.stat().st_size
            w.unlink()
            print(f"  deleted {w.name}")
    return freed


def main() -> int:
    print("== 1. Rewriting all.min.css ==")
    rewrite_css()

    print("\n== 2. Deleting .ttf files ==")
    ttf_freed = delete_ttf()
    print(f"  freed {ttf_freed:,} bytes ({ttf_freed / 1024 / 1024:.1f} MB) of .ttf")

    print("\n== 3. Deleting unused .woff2 files ==")
    woff_freed = delete_unused_woff2()
    print(f"  freed {woff_freed:,} bytes ({woff_freed / 1024:.0f} KB) of unused .woff2")

    print("\n== Remaining webfonts ==")
    for f in sorted(FONTS.iterdir()):
        print(f"  {f.name:35s} {f.stat().st_size:>8,} bytes")

    return 0


if __name__ == "__main__":
    sys.exit(main())
