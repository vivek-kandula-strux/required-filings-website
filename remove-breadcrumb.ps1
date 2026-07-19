# Remove <nav class="rf-service-hero__breadcrumb ..."> ... </nav> block from every inner page.
# UTF-8 safe read/write per CLAUDE.md encoding rule.

$root = Join-Path $PSScriptRoot 'required-filings'
$files = Get-ChildItem -Path $root -Filter *.html -File

$pattern = '(?ms)^[ \t]+<nav class="rf-service-hero__breadcrumb[^"]*" aria-label="Breadcrumb">.*?</nav>\r?\n'

$encoding = New-Object System.Text.UTF8Encoding($false)
$hits = 0

foreach ($f in $files) {
    $text = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $new = [regex]::Replace($text, $pattern, '')
    if ($new -ne $text) {
        [System.IO.File]::WriteAllText($f.FullName, $new, $encoding)
        Write-Host ("stripped: {0}" -f $f.Name)
        $hits++
    }
}

Write-Host ("done - {0} file(s) updated." -f $hits)
