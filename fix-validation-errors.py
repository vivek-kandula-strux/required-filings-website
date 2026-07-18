"""
Fix remaining HTML validation errors across all 20 pages:

1. Add type="button" to back-to-top button (no-implicit-button-type)
2. Change <div class="icon..."> inside accordion <button> to <span> (element-permitted-content)
3. Replace spaces in phone number text (not href/attr values) with &nbsp; (tel-non-breaking)
4. Change <h4>Contact Info</h4> in offcanvas to <p class="offcanvas-contact-heading">
"""
import re, os

BASE = r"d:\Website Projects\Required Filings Website\required-filings"
PAGES = [
    "404.html", "about.html", "accounting.html", "blog.html",
    "contact.html", "disclaimer.html", "gst-services.html", "index.html",
    "ipr.html", "iso-certification.html", "licenses.html", "msme-zed.html",
    "privacy.html", "refund.html", "roc-compliance.html", "services.html",
    "start-a-business.html", "statutory-registrations.html",
    "tax-services.html", "terms.html",
]

def read(p):
    return open(p, encoding='utf-8').read()

def write(p, content):
    with open(p, 'w', encoding='utf-8', newline='') as f:
        f.write(content)

for page in PAGES:
    path = os.path.join(BASE, page)
    content = read(path)
    original = content
    changes = []

    # Fix 1: Add type="button" to back-to-top button
    if '<button id="back-top" class="back-to-top"' in content:
        content = content.replace(
            '<button id="back-top" class="back-to-top"',
            '<button id="back-top" type="button" class="back-to-top"'
        )
        changes.append("type=button on back-to-top")

    # Fix 2: Change <div class="icon..."> inside accordion button to <span>
    # Matches the plus/minus icon div inside accordion trigger buttons
    count_before = content.count('<div class="icon ')
    content = re.sub(
        r'<div (class="icon [^"]*" aria-hidden="true")></div>',
        r'<span \1></span>',
        content
    )
    count_after = content.count('<div class="icon ')
    if count_before != count_after:
        changes.append("div->span for %d accordion icon(s)" % (count_before - count_after))

    # Fix 3: Replace spaces in phone number display text with &nbsp;
    # Match "+91 95027 15353" only in text nodes (preceded by > or whitespace/newline after >)
    # This avoids replacing inside attribute values like aria-label="..."
    # The phone appears as ">+91 95027 15353<" or ">+91 95027 15353\n"
    phone_plain = r'\+91 95027 15353'
    phone_nbsp  = '+91 95027 15353'  # Using actual NBSP char (U+00A0)
    # Actually html-validate wants the HTML entity, not the char. Use &nbsp; string.
    phone_nbsp_html = '+91&nbsp;95027&nbsp;15353'

    # Replace only occurrences that appear after ">" (in text content, not attributes)
    # Look for ">" immediately or within whitespace before the phone number
    new_content = re.sub(
        r'(?<=>)\+91 95027 15353',
        phone_nbsp_html,
        content
    )
    # Also catch the case where phone is after whitespace following ">"
    # e.g. ">\n                            +91 95027 15353"
    new_content = re.sub(
        r'(\n[ \t]+)\+91 95027 15353',
        r'\1' + phone_nbsp_html,
        new_content
    )
    if new_content != content:
        count = content.count('+91 95027 15353') - new_content.count('+91 95027 15353')
        changes.append("&nbsp; in %d phone text occurrences" % count)
        content = new_content

    # Fix 4: Change <h4>Contact Info</h4> in offcanvas to <p>
    if '<h4>Contact Info</h4>' in content:
        content = content.replace(
            '<h4>Contact Info</h4>',
            '<p class="offcanvas-contact-heading">Contact Info</p>'
        )
        changes.append("h4->p for offcanvas contact heading")

    if content != original:
        write(path, content)
        print("FIXED %-40s %s" % (page, " | ".join(changes)))
    else:
        print("SKIP  %s" % page)
