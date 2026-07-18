"""
Fix close-order HTML errors across 20 pages.

Two fix types:
1. Pages with unclosed section (9 pages): an extra </div> appears between
   </div></div> and </section> at the end of the feature-section grid.
   Remove it.

2. Pages with a stray trailing </div> (about.html, index.html): the last
   </div> after the footer close block is extra. Remove it.
"""
import re
import os

BASE = r"d:\Website Projects\Required Filings Website\required-filings"

def read(path):
    return open(path, encoding='utf-8').read()

def write(path, content):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        f.write(content)

def count_div_balance(content):
    opens = len(re.findall(r'<div[\s>]', content))
    closes = len(re.findall(r'</div>', content))
    return closes - opens  # positive = too many closes

# --- Fix type 1: remove extra </div> between </div></div> and </section> ---
# The pattern: a line with </div></div>, then a line with only </div>,
# then a line with </section> (which closes the feature section).
# The </div></div> + </div> + </section> sequence is unique to the
# feature-section grid close on service pages.

TYPE1_PAGES = [
    "gst-services.html",
    "ipr.html",
    "iso-certification.html",
    "licenses.html",
    "roc-compliance.html",
    "services.html",
    "start-a-business.html",
    "statutory-registrations.html",
    "tax-services.html",
]

# Matches: </div></div>\n<whitespace></div>\n<whitespace></section>
# Captures the first and third lines, drops the middle one.
PATTERN_TYPE1 = re.compile(
    r'([ \t]*</div></div>[ \t]*\n)[ \t]*</div>[ \t]*\n([ \t]*</section>)',
    re.MULTILINE
)

for page in TYPE1_PAGES:
    path = os.path.join(BASE, page)
    content = read(path)
    before = count_div_balance(content)
    new_content, n = PATTERN_TYPE1.subn(r'\1\2', content)
    after = count_div_balance(new_content)
    if n == 1:
        write(path, new_content)
        print(f"FIXED {page}: removed 1 extra </div> (balance {before} -> {after})")
    elif n == 0:
        print(f"SKIP  {page}: pattern not found (balance={before})")
    else:
        print(f"WARN  {page}: pattern matched {n} times — not applied (balance={before})")

# --- Fix type 2: remove stray trailing </div> at end of page ---
# about.html and index.html each have one too many </div> closes
# after the footer close block. They appear as depth<0 at the very end.
# The stray </div> is the last one before the scripts block.

TYPE2_PAGES = [
    "about.html",
    "index.html",
]

# The stray </div> appears right before the script tags (<!--<< All JS Plugins >>-->)
# Pattern: </div>\n\n\s*(<!--<< All JS Plugins|<script)
PATTERN_TYPE2 = re.compile(
    r'([ \t]*</div>[ \t]*\n)([ \t]*\n[ \t]*(?:<!--.*?All JS Plugins|<script))',
    re.MULTILINE
)

for page in TYPE2_PAGES:
    path = os.path.join(BASE, page)
    content = read(path)
    before = count_div_balance(content)
    # Find all matches and remove only the last stray one
    matches = list(PATTERN_TYPE2.finditer(content))
    if matches:
        # Take the last match
        m = matches[-1]
        new_content = content[:m.start()] + m.group(2) + content[m.end():]
        after = count_div_balance(new_content)
        write(path, new_content)
        print(f"FIXED {page}: removed stray trailing </div> (balance {before} -> {after})")
    else:
        print(f"SKIP  {page}: pattern not found (balance={before})")
