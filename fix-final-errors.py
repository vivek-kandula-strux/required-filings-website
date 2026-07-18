"""
Final validation error fixes:
1. Add type="button" to carousel prev/next on index.html
2. Fix phone &nbsp; in contact-side trust link (service pages)
3. Fix phone &nbsp; in contact page call card
4. Fix mobile bar tel: link: </i> Call us -> </i>&nbsp;Call us (all pages)
"""
import os

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

    # Fix 1: carousel buttons on index.html
    if page == "index.html":
        if '<button class="array-prev"' in content:
            content = content.replace(
                '<button class="array-prev"',
                '<button type="button" class="array-prev"'
            )
            changes.append("type=button on array-prev")
        if '<button class="array-next"' in content:
            content = content.replace(
                '<button class="array-next"',
                '<button type="button" class="array-next"'
            )
            changes.append("type=button on array-next")

    # Fix 2: mobile bar "Call us" space inside tel: link (all pages)
    if '></i> Call us' in content:
        content = content.replace('></i> Call us', '></i>&nbsp;Call us')
        changes.append("&nbsp; before Call us in mobile bar")

    # Fix 3: contact-side trust link phone number (service pages)
    if '</i> +91 95027 15353</a>' in content:
        content = content.replace(
            '</i> +91 95027 15353</a>',
            '</i>&nbsp;+91&nbsp;95027&nbsp;15353</a>'
        )
        changes.append("&nbsp; in contact-side phone link")

    # Fix 4: contact.html call card phone text
    if page == "contact.html" and 'Phone: +91 95027 15353' in content:
        content = content.replace(
            'Phone: +91 95027 15353',
            'Phone:&nbsp;+91&nbsp;95027&nbsp;15353'
        )
        changes.append("&nbsp; in contact page call card")

    if content != original:
        write(path, content)
        print("FIXED %-40s %s" % (page, " | ".join(changes)))
    else:
        print("SKIP  %s" % page)
