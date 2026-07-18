# Swap logo/*.svg -> logo/*.png in every HTML page.
# UTF-8 safe read/write per CLAUDE.md encoding rule.

$ErrorActionPreference = 'Stop'
$root = Join-Path $PSScriptRoot 'required-filings'
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

$replacements = @{
    'logo/black-logo.svg' = 'logo/black-logo.png'
    'logo/white-logo.svg' = 'logo/white-logo.png'
}

$files = Get-ChildItem -Path $root -Filter '*.html' -File
$totalChanges = 0

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $original = $content
    $pageChanges = 0

    foreach ($old in $replacements.Keys) {
        $new = $replacements[$old]
        # count before + after
        $count = ([regex]::Matches($content, [regex]::Escape($old))).Count
        if ($count -gt 0) {
            $content = $content.Replace($old, $new)
            $pageChanges += $count
        }
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        Write-Host ("  {0,-32} {1} replacement(s)" -f $file.Name, $pageChanges)
        $totalChanges += $pageChanges
    }
}

Write-Host ''
Write-Host ("Total replacements: {0}" -f $totalChanges) -ForegroundColor Green
