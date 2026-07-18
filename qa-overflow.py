"""
Headless-Chrome overflow probe.
Loads each target page at multiple viewports, evaluates
document.querySelectorAll('*') and reports every element whose right
edge exceeds the viewport width. Uses Chrome DevTools Protocol via
a small evaluation script written into a temporary HTML wrapper
(--print-to-pdf trick / --run-web-tests are Chromium-internal).

Simpler approach: use --enable-logging=stderr and inject our
diagnostic via a bookmarklet-style javascript: URL. Chrome headless
does NOT execute javascript: URLs from the command line, so we
inject the probe by appending a <script> at load time via a tiny
Puppeteer-free path: rely on the existing ?rfQA=1 hook already wired
into main.js, then capture console.groupCollapsed output via
--enable-logging.
"""
import subprocess
import re
import sys, io
from pathlib import Path

# Force stdout to UTF-8 so we can print arrows without Windows cp1252 choking.
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

REPO   = Path(r"d:/Website Projects/Required Filings Website")
PAGES  = REPO / "required-filings"
CHROME = Path(r"C:\Program Files\Google\Chrome\Application\chrome.exe")

TARGETS = ["index.html", "contact.html", "about.html"]
VIEWPORTS = [(360, 640), (414, 896), (768, 1024)]

def probe(page, w, h):
    src = PAGES / page
    url = "file:///" + str(src).replace("\\", "/") + "?rfQA=1"
    cmd = [
        str(CHROME),
        "--headless=new",
        "--disable-gpu",
        "--no-sandbox",
        f"--window-size={w},{h}",
        "--enable-logging=stderr",
        "--log-level=0",
        "--v=0",
        "--virtual-time-budget=6000",
        "--dump-dom",
        url,
    ]
    r = subprocess.run(cmd, capture_output=True, text=True,
                       timeout=60, encoding='utf-8', errors='replace')
    # console output lands in stderr under --enable-logging=stderr
    console = r.stderr
    matches = re.findall(r"\[rfQA\][^\n]*", console)
    detail  = re.findall(r"→[^\n]*", console)
    return matches, detail

def main():
    for page in TARGETS:
        for w, h in VIEWPORTS:
            headers, offenders = probe(page, w, h)
            print(f"\n{page} @ {w}x{h}")
            for h_ in headers:
                print("  ", h_.strip())
            if offenders:
                for line in offenders[:20]:
                    print("     ", line.strip())
            else:
                print("     (no console output captured)")

if __name__ == "__main__":
    main()
