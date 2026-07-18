# Phase 3 — Header & Navigation fixes
# Run from repo root: powershell -ExecutionPolicy Bypass -File .\phase3-header-fix.ps1

$dir = "d:\Website Projects\Required Filings Website\required-filings"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$pages = Get-ChildItem -Path $dir -Filter "*.html" | Select-Object -ExpandProperty FullName

$changed = 0
foreach ($path in $pages) {
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    $original = $content
    $leaf = Split-Path -Leaf $path

    # ── Fix 1: Hamburger breakpoint d-xxl-none → d-xl-none ──────────────────
    $content = $content.Replace(
        '<div class="header__hamburger d-xxl-none my-auto">',
        '<div class="header__hamburger d-xl-none my-auto">'
    )

    # ── Fix 2: CTA href → contact.html (only the theme-btn in header) ────────
    $content = $content -replace '(<a href=")tel:\+919502715353(" class="theme-btn d-none d-xxl-block">)', '$1contact.html$2'

    # ── Fix 3: CTA button text → "Talk to a Filing Expert" ───────────────────
    $content = $content.Replace(
        '<span>+91&nbsp;95027&nbsp;15353</span>',
        '<span>Talk to a Filing Expert</span>'
    )

    # ── Fix 4: Replace call.svg img elements with Font Awesome phone icon ─────
    if ($content -match 'assets/img/call\.svg') {
        $content = $content -replace '<img src="assets/img/call\.svg"[^>]*/?>',
            '<i class="fa-solid fa-phone" aria-hidden="true"></i>'
    }

    # ── Fix 5: Remove .header-left wrapper (present on 19 inner pages) ────────
    if ($content.Contains('<div class="header-left">')) {
        # Remove the opening tag line
        $content = $content -replace '(?m)^[ \t]*<div class="header-left">[ \t]*\r?\n', ''
        # Remove the now-orphaned closing </div> that is directly before header-right
        # Pattern: </div> on its own line, then header-right on the next line
        $content = $content -replace '([ \t]*</div>)(\r?\n)([ \t]*<div class="header-right d-flex justify-content-end align-items-center">)', '$2$3'
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "  Updated: $leaf"
        $changed++
    } else {
        Write-Host "  No change: $leaf"
    }
}

Write-Host ""
Write-Host "Done. $changed / $($pages.Count) pages updated."
