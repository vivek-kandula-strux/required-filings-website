"""
Generate 800w and 1200w responsive variants of hero-bg and about-image.
Preserves original aspect ratio. WebP at quality 82, JPEG at quality 85.
Idempotent — safe to re-run.
"""
from PIL import Image
from pathlib import Path

ROOT = Path(r"d:/Website Projects/Required Filings Website/required-filings/assets/img")

TARGETS = [
    ROOT / "home-1" / "hero" / "hero-bg.jpg",
    ROOT / "inner-page" / "about-image.jpg",
]

WIDTHS = [800, 1200]

for src in TARGETS:
    if not src.exists():
        print(f"SKIP: {src} (not found)")
        continue
    im = Image.open(src).convert("RGB")
    orig_w, orig_h = im.size
    stem = src.stem
    parent = src.parent

    for w in WIDTHS:
        if w >= orig_w:
            print(f"SKIP: {src.name} @ {w}w (would upscale from {orig_w}w)")
            continue
        h = round(orig_h * w / orig_w)
        resized = im.resize((w, h), Image.LANCZOS)

        # JPEG variant
        jpg_out = parent / f"{stem}-{w}w.jpg"
        resized.save(jpg_out, "JPEG", quality=85, optimize=True, progressive=True)

        # WebP variant
        webp_out = parent / f"{stem}-{w}w.webp"
        resized.save(webp_out, "WEBP", quality=82, method=6)

        print(f"OK: {jpg_out.name} ({jpg_out.stat().st_size // 1024} KB), "
              f"{webp_out.name} ({webp_out.stat().st_size // 1024} KB)")

print("Done.")
