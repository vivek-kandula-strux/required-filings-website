$cssPath = 'd:\Website Projects\Required Filings Website\required-filings\assets\css\main.css'
$htmlDir = 'd:\Website Projects\Required Filings Website\required-filings'
$enc = [System.Text.Encoding]::UTF8

$css = [System.IO.File]::ReadAllText($cssPath, $enc)
$htmlFiles = Get-ChildItem "$htmlDir\*.html"
$allHtml = ($htmlFiles | ForEach-Object { [System.IO.File]::ReadAllText($_.FullName, $enc) }) -join ' '

$candidates = @(
    'testimonial-slider', 'testimonial-section', 'testimonial-box', 'testimonial-thumb',
    'team-section', 'team-card', 'team-box',
    'brand-section', 'brand-slider', 'brand-box',
    'pricing-section', 'pricing-box',
    'news-section', 'news-box', 'news-card',
    'color-palate', 'color-switcher',
    'search-popup', 'search-toggler',
    'preloader'
)

Write-Host "=== CSS Component Audit ==="
foreach ($cls in $candidates) {
    $inCss  = [bool][regex]::Match($css, [regex]::Escape($cls)).Success
    $inHtml = [bool][regex]::Match($allHtml, [regex]::Escape($cls)).Success
    $status = if ($inCss -and -not $inHtml) { "REMOVABLE" } elseif ($inCss -and $inHtml) { "IN USE   " } else { "NOT IN CSS" }
    Write-Host "  $status : $cls"
}

# Count CSS lines for removed components (rough estimate)
Write-Host ""
Write-Host "CSS file size: $([math]::Round($css.Length/1024, 1)) KB"
