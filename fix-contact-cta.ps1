# Fix contact-section-2 (per elite UI/UX review 2026-07-19):
# 1. Remove inline background-image attribute (kill broken AI photo). CSS now handles bg.
# 2. Change dropdown default so placeholder shows by default and required forces a real pick.
# UTF-8 safe read/write per CLAUDE.md encoding rule.

$root = Join-Path $PSScriptRoot 'required-filings'
$files = Get-ChildItem -Path $root -Filter *.html -File

$encoding = New-Object System.Text.UTF8Encoding($false)
$hits = 0

foreach ($f in $files) {
    $text = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $orig = $text

    # 1. Strip inline background-image on contact-section-2
    $text = [regex]::Replace(
        $text,
        '(<section class="contact-section-2[^"]*"[^>]*?)\s+style="background-image:\s*url\(''assets/img/inner-page/contact-bg\.(?:jpg|webp)''\);"',
        '$1'
    )

    # 2a. Turn the placeholder option into selected + disabled + value=""
    $text = $text -replace '<option>What do you need\?</option>', '<option value="" selected disabled>What do you need?</option>'

    # 2b. Remove `selected` from the (single) currently-selected option per file
    $text = [regex]::Replace($text, '<option selected>', '<option>')

    if ($text -ne $orig) {
        [System.IO.File]::WriteAllText($f.FullName, $text, $encoding)
        Write-Host ("patched: {0}" -f $f.Name)
        $hits++
    }
}

Write-Host ("done - {0} file(s) updated." -f $hits)
