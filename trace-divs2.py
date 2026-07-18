import re

def trace_divs_verbose(filepath, show_lines=None):
    with open(filepath, encoding='utf-8') as f:
        lines = f.readlines()
    depth = 0
    for i, line in enumerate(lines, 1):
        opens = len(re.findall(r'<div[\s>]', line))
        closes = len(re.findall(r'</div>', line))
        depth += opens - closes
        if show_lines is None or i in show_lines or depth < 0 or (opens > 0 or closes > 0) and i > 710:
            if i in (show_lines or []) or depth < 0:
                flag = " <--- DEPTH=%d" % depth if depth < 0 else " [depth=%d]" % depth
                print("  %4d: opens=%d closes=%d depth=%d %s" % (i, opens, closes, depth, line.rstrip()[:80]))

# Show lines 440-450 and 710-725 for gst-services
filepath = 'required-filings/gst-services.html'
with open(filepath, encoding='utf-8') as f:
    lines = f.readlines()

print("=== gst-services.html: lines 440-452 ===")
depth = 0
for i, line in enumerate(lines, 1):
    opens = len(re.findall(r'<div[\s>]', line))
    closes = len(re.findall(r'</div>', line))
    depth += opens - closes
    if 440 <= i <= 452:
        print("  %4d [depth=%2d]: %s" % (i, depth, line.rstrip()[:90]))

print("\n=== gst-services.html: lines 713-722 ===")
depth2 = 0
for i, line in enumerate(lines, 1):
    opens = len(re.findall(r'<div[\s>]', line))
    closes = len(re.findall(r'</div>', line))
    depth2 += opens - closes
    if 713 <= i <= 722:
        print("  %4d [depth=%2d]: %s" % (i, depth2, line.rstrip()[:90]))
