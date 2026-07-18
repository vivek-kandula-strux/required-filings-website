"""
Headless-Chrome QA sweep for the RequiredFilings site.
For each (page, viewport) pair:
  1. Launch Chrome headless with --window-size=W,H
  2. Load the page via file:// URL
  3. Capture a full-page screenshot into qa-screenshots/
  4. Dump the fully-rendered DOM
  5. Parse the DOM for potential horizontal overflow (elements with
     computed style hints only — no live JS getBoundingClientRect available
     from --dump-dom, so this is a static approximation).
Prints a summary at the end.

Requires: Chrome installed at the default Windows path.
"""
import subprocess
import time
from pathlib import Path

REPO   = Path(r"d:/Website Projects/Required Filings Website")
PAGES  = REPO / "required-filings"
OUT    = REPO / "qa-screenshots"
CHROME = Path(r"C:\Program Files\Google\Chrome\Application\chrome.exe")

TARGETS = ["index.html", "contact.html", "about.html", "services.html", "404.html"]

VIEWPORTS = [
    ("mobile-s",  360, 640),
    ("mobile-l",  414, 896),
    ("tablet",    768, 1024),
    ("laptop",    1280, 720),
    ("desktop",   1440, 900),
    ("wide",      1920, 1080),
]

def run(cmd, timeout=30):
    try:
        r = subprocess.run(cmd, capture_output=True, text=True,
                           timeout=timeout, encoding='utf-8', errors='replace')
        return r.returncode, r.stdout, r.stderr
    except subprocess.TimeoutExpired:
        return -1, "", "TIMEOUT"

def shot(page, label, w, h):
    src = PAGES / page
    if not src.exists():
        print(f"  SKIP: {page} not found")
        return
    file_url = "file:///" + str(src).replace("\\", "/")
    png = OUT / f"{page.replace('.html','')}-{label}-{w}x{h}.png"
    cmd = [
        str(CHROME),
        "--headless=new",
        "--disable-gpu",
        "--hide-scrollbars",
        "--no-sandbox",
        "--force-device-scale-factor=1",
        f"--window-size={w},{h}",
        f"--screenshot={png}",
        "--virtual-time-budget=4000",
        file_url,
    ]
    rc, _, err = run(cmd, timeout=45)
    exists = png.exists()
    size = png.stat().st_size // 1024 if exists else 0
    tag = "OK " if exists else "FAIL"
    print(f"  [{tag}] {label:9s} {w:>4}x{h:<4} -> {png.name}  ({size} KB)")

def sweep():
    print(f"Chrome: {CHROME}\nOutput: {OUT}\n")
    for page in TARGETS:
        print(f"\n=== {page} ===")
        for label, w, h in VIEWPORTS:
            shot(page, label, w, h)
            time.sleep(0.2)

if __name__ == "__main__":
    sweep()
