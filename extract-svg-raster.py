"""
Extract embedded base64 raster from RequiredFilings SVG logos and re-encode as
properly-sized PNG + WebP variants.

Why: the SVG files were exported from a design tool that wrapped a raster PNG
in an SVG container. 99% of each file's weight is the base64-encoded raster —
which SVGO cannot strip. Ship the raster directly at the actual rendered size.

Outputs (into assets/img/logo/ and assets/img/):
  - black-logo.png (360x360, retina for 180x180 render)
  - black-logo.webp
  - white-logo.png
  - white-logo.webp
  - favicon-32.png, favicon-180.png (already exist, verify)
  - favicon.png (higher-res replacement for the 373 KB SVG)
"""
import base64
import io
import re
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).parent
IMG = ROOT / "required-filings" / "assets" / "img"

TARGETS = [
    # (source_svg, out_stem, target_px)
    (IMG / "logo" / "black-logo.svg", IMG / "logo" / "black-logo", 360),
    (IMG / "logo" / "white-logo.svg", IMG / "logo" / "white-logo", 360),
    (IMG / "favicon.svg", IMG / "favicon", 512),
]

# Match: xlink:href="data:image/png;base64,AAAA..." or href="data:..."
DATA_URI = re.compile(
    rb'(?:xlink:)?href="data:image/(png|jpe?g|webp);base64,([A-Za-z0-9+/=\s]+)"'
)


def extract_raster(svg_path: Path) -> tuple[str, bytes] | None:
    data = svg_path.read_bytes()
    m = DATA_URI.search(data)
    if not m:
        return None
    fmt = m.group(1).decode()
    b64 = m.group(2)
    # base64 payload may have whitespace/newlines — strip it
    b64_clean = b"".join(b64.split())
    raw = base64.b64decode(b64_clean)
    return fmt, raw


def process(svg_path: Path, out_stem: Path, target_px: int) -> None:
    print(f"\n== {svg_path.name} ==")
    print(f"  source size: {svg_path.stat().st_size:>8,} bytes")

    result = extract_raster(svg_path)
    if result is None:
        print("  ! no embedded raster found — skipping")
        return

    fmt, raw = result
    print(f"  embedded raster: {fmt}, {len(raw):,} raw bytes")

    with Image.open(io.BytesIO(raw)) as im:
        print(f"  raster dimensions: {im.size}")
        # Ensure RGBA for transparency support
        if im.mode not in ("RGBA", "LA"):
            im = im.convert("RGBA")

        # Resize using high-quality Lanczos, preserving aspect
        if max(im.size) != target_px:
            ratio = target_px / max(im.size)
            new_size = (int(im.size[0] * ratio), int(im.size[1] * ratio))
            resized = im.resize(new_size, Image.Resampling.LANCZOS)
        else:
            resized = im

        png_out = out_stem.with_suffix(".png")
        webp_out = out_stem.with_suffix(".webp")

        resized.save(png_out, "PNG", optimize=True, compress_level=9)
        resized.save(webp_out, "WEBP", quality=88, method=6)

        print(f"  -> {png_out.name}:  {png_out.stat().st_size:>8,} bytes  ({resized.size[0]}x{resized.size[1]})")
        print(f"  -> {webp_out.name}: {webp_out.stat().st_size:>8,} bytes")


def main() -> int:
    for svg, stem, px in TARGETS:
        if not svg.exists():
            print(f"! missing: {svg}", file=sys.stderr)
            return 1
        process(svg, stem, px)
    return 0


if __name__ == "__main__":
    sys.exit(main())
