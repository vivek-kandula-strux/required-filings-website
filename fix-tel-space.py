import os

BASE = r"d:\Website Projects\Required Filings Website\required-filings"
PAGES = [
    "404.html","about.html","accounting.html","blog.html","contact.html",
    "disclaimer.html","gst-services.html","index.html","ipr.html",
    "iso-certification.html","licenses.html","msme-zed.html","privacy.html",
    "refund.html","roc-compliance.html","services.html","start-a-business.html",
    "statutory-registrations.html","tax-services.html","terms.html",
]
for page in PAGES:
    path = os.path.join(BASE, page)
    content = open(path, encoding='utf-8').read()
    original = content
    content = content.replace('></i>&nbsp;Call us', '></i>&nbsp;Call&nbsp;us')
    if content != original:
        with open(path, 'w', encoding='utf-8', newline='') as f:
            f.write(content)
        print("FIXED " + page)
    else:
        print("SKIP  " + page)
