import re

def trace_divs(filepath):
    with open(filepath, encoding='utf-8') as f:
        lines = f.readlines()
    depth = 0
    issues = []
    for i, line in enumerate(lines, 1):
        opens = len(re.findall(r'<div[\s>]', line))
        closes = len(re.findall(r'</div>', line))
        for _ in range(opens):
            depth += 1
        for _ in range(closes):
            depth -= 1
            if depth < 0:
                msg = "  Line %d (depth<0): %s" % (i, line.rstrip()[:100])
                issues.append(msg)
                depth = 0
    return depth, issues

files = [
    'required-filings/gst-services.html',
    'required-filings/about.html',
    'required-filings/index.html',
]
for f in files:
    net, issues = trace_divs(f)
    print("\n%s: net_unclosed=%d, underflows=%d" % (f, net, len(issues)))
    for iss in issues:
        print(iss)
