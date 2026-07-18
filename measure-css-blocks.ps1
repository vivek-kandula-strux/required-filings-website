# Measure approximate line ranges of template component CSS blocks
$cssPath = 'd:\Website Projects\Required Filings Website\required-filings\assets\css\main.css'
$enc = [System.Text.Encoding]::UTF8
$lines = [System.IO.File]::ReadAllText($cssPath, $enc) -split "`n"

# Keywords to look for (block start markers)
$components = @(
    'testimonial',
    'team-section', 'team-card', 'team-box',
    'brand-section', 'brand-slider',
    'pricing-section', 'pricing-box',
    'news-box', 'news-card',
    'color-palate', 'color-switcher',
    'search-popup', 'search-toggler',
    'preloader'
)

Write-Host "Lines containing removed-component selectors:"
foreach ($cls in $components) {
    $count = ($lines | Where-Object { $_ -match [regex]::Escape($cls) }).Count
    Write-Host "  $cls : $count lines"
}

Write-Host ""
Write-Host "Total CSS lines: $($lines.Count)"
