"""
Remove the stray </div> that appears after the footer close block.
All affected pages have </footer> followed by exactly 3 </div> lines
(rf-scroll-content, rf-scroll-wrapper, page-wrapper) but one is stray.
Pattern: remove the last of the 3 </div> lines that follow </footer>.
"""
import re
import os

BASE = r"d:\Website Projects\Required Filings Website\required-filings"

def read(path):
    return open(path, encoding='utf-8').read()

def write(path, content):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        f.write(content)

def count_diff(content):
    opens = len(re.findall(r'<div[\s>]', content))
    closes = len(re.findall(r'</div>', content))
    return closes - opens

PAGES = [
    "gst-services.html",
    "ipr.html",
    "iso-certification.html",
    "licenses.html",
    "roc-compliance.html",
    "services.html",
    "start-a-business.html",
    "statutory-registrations.html",
    "tax-services.html",
    "about.html",
    "index.html",
]

# Match </footer> then 3 lines each containing only </div> (with leading whitespace)
# Capture groups: (1)=footer tag line, (2)=first </div>, (3)=second </div>, stray </div> removed
PATTERN = re.compile(
    r'([ \t]*</footer>[ \t]*\n'
    r'[ \t]*</div>[ \t]*\n'
    r'[ \t]*</div>[ \t]*\n)'
    r'[ \t]*</div>[ \t]*\n',
    re.MULTILINE
)

for page in PAGES:
    path = os.path.join(BASE, page)
    content = read(path)
    before = count_diff(content)
    new_content, n = PATTERN.subn(r'\1', content)
    after = count_diff(new_content)
    if n == 1:
        write(path, new_content)
        print("FIXED %-36s balance %d -> %d" % (page, before, after))
    elif n == 0:
        print("SKIP  %-36s pattern not found (balance=%d)" % (page, before))
    else:
        print("WARN  %-36s matched %d times — not applied" % (page, n))
