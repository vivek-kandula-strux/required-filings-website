# Removes the preloader block and pricing-section from every page.
# Both were previously locked in the wireframe; user override 2026-06-29.

$root = 'd:\Website Projects\Required Filings Website\required-filings'
$htmls = Get-ChildItem $root -Filter *.html -File
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Regex 1: preloader block. Match "<!-- Preloader Start -->" through the closing </div>
# of <div id="preloader"...>. The structure has 3 nested div levels — non-greedy regex
# cannot count braces, so we match the exact known shape.
$preloaderRx = '(?s)\s*<!-- Preloader Start -->\s*<div id="preloader"[^>]*>.*?</div>\s*</div>\s*</div>'

# Regex 2: pricing-section block. Marker comment + opening <section class="pricing-section
# ..."> + everything up to the matching </section>.
$pricingRx = '(?s)\s*<!-- Pricing Section Start -->\s*<section class="pricing-section[^"]*">.*?</section>'

$changed = 0
foreach ($h in $htmls) {
    $c = [System.IO.File]::ReadAllText($h.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c

    # Preloader
    $c = [regex]::Replace($c, $preloaderRx, '', 1)

    # Pricing
    $c = [regex]::Replace($c, $pricingRx, '')

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        $changed++
        Write-Host "Removed: $($h.Name)"
    }
}
Write-Host "Total files updated: $changed"
