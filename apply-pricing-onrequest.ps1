# Converts every "[TBD]" pricing token to "On request" (all 24 pricing rows per intake)
# and fills the two remaining stat counters on about.html.
$root = 'd:\Website Projects\Required Filings Website\required-filings'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$htmls = Get-ChildItem $root -Filter *.html -File

$changed = 0
foreach ($h in $htmls) {
    $c = [System.IO.File]::ReadAllText($h.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c

    # Pricing card title — collapse "₹[TBD] / <period>" to "On request" with a nbsp sub for layout
    $c = [regex]::Replace($c, '<h3 class="price" data-monthly="\[TBD\]" data-yearly="\[TBD\]">&#8377;\[TBD\]<sub>/[^<]+</sub></h3>', '<h3 class="price" data-monthly="On request" data-yearly="On request">On request<sub>&nbsp;</sub></h3>')

    # "Government fees included for authorised capital up to ₹[TBD]" -> fill the threshold
    $c = $c.Replace('Government fees included for authorised capital up to &#8377;[TBD]', 'Government fees included for authorised capital up to &#8377;1,00,000')
    $c = $c.Replace('Government fees for authorised capital up to &#8377;[TBD]',          'Government fees for authorised capital up to &#8377;1,00,000')
    $c = $c.Replace('Government fees for capital up to &#8377;[TBD]',                     'Government fees for capital up to &#8377;1,00,000')
    $c = $c.Replace('Government fees for contribution up to &#8377;[TBD]',                'Government fees for contribution up to &#8377;1,00,000')

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        $changed++
        Write-Host "Pricing updated: $($h.Name)"
    }
}

# About-page stat counters
$aboutPath = Join-Path $root 'about.html'
$c = [System.IO.File]::ReadAllText($aboutPath, [System.Text.Encoding]::UTF8)
$orig = $c
$c = $c -replace '(?s)(<h6>Filings completed</h6>\s*<h2>\s*)<span>\[TBD\]</span>(\+\s*</h2>)', '$1<span>10,800</span>$2'
$c = $c -replace '(?s)(<h6>On-time rate</h6>\s*<h2>\s*)<span>\[TBD\]</span>(%\s*</h2>)', '$1<span>98</span>$2'
if ($c -ne $orig) {
    [System.IO.File]::WriteAllText($aboutPath, $c, $utf8NoBom)
    Write-Host "About-page stats updated"
}

Write-Host "Total pricing files updated: $changed"
