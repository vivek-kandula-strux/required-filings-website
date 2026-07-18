# Add type="button" + aria-label to the back-to-top button on all pages.
# Fixes html-validate: no-implicit-button-type and text-content errors.
# UTF-8 safe per CLAUDE.md rule.

$ErrorActionPreference = 'Stop'
$root = Join-Path $PSScriptRoot 'required-filings'
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

$old = '<button id="back-top" class="back-to-top">'
$new = '<button id="back-top" type="button" class="back-to-top" aria-label="Back to top">'

$files = Get-ChildItem -Path $root -Filter '*.html' -File
$fixed = 0

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content.Contains($old)) {
        $content = $content.Replace($old, $new)
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        $fixed++
        Write-Host "  fixed: $($file.Name)"
    }
}
Write-Host ''
Write-Host "Total: $fixed pages fixed" -ForegroundColor Green
