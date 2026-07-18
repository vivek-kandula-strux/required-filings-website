# Remove unused CSS link tags from HTML pages
$dir = 'd:\Website Projects\Required Filings Website\required-filings'
$enc = [System.Text.Encoding]::UTF8
$encNoBOM = New-Object System.Text.UTF8Encoding $false

# Pages that use swiper (keep swiper CSS)
$hasSwiper = @('index')
# Pages that use nice-select (keep nice-select CSS)
$hasNiceSelect = @('start-a-business','contact','gst-services','services','ipr',
                   'iso-certification','roc-compliance','tax-services','statutory-registrations','licenses')

$pages = Get-ChildItem "$dir\*.html"
$totalRemoved = 0

foreach ($f in $pages) {
    $base = $f.BaseName
    $content = [System.IO.File]::ReadAllText($f.FullName, $enc)
    $orig = $content
    $removed = @()

    # Remove magnific-popup.css from all pages (no page uses it now)
    $before = $content
    $content = [regex]::Replace($content, '\s*<link\s+rel="stylesheet"\s+href="assets/css/magnific-popup\.css">', '')
    if ($content -ne $before) { $removed += 'magnific-popup.css' }

    # Remove also the orphaned comment for magnific if present
    $content = [regex]::Replace($content, '\s*<!--<< Magnific Popup\.css >>-->', '')

    # Remove swiper CSS from non-swiper pages
    if ($hasSwiper -notcontains $base) {
        $before = $content
        $content = [regex]::Replace($content, '\s*<link\s+rel="stylesheet"\s+href="assets/css/swiper-bundle\.min\.css">', '')
        if ($content -ne $before) { $removed += 'swiper-bundle.min.css' }
        # Remove orphaned comment
        $content = [regex]::Replace($content, '\s*<!--<< Swiper Bundle\.css >>-->', '')
    }

    # Remove nice-select CSS from pages that don't use it
    if ($hasNiceSelect -notcontains $base) {
        $before = $content
        $content = [regex]::Replace($content, '\s*<link\s+rel="stylesheet"\s+href="assets/css/nice-select\.css">', '')
        if ($content -ne $before) { $removed += 'nice-select.css' }
        # Remove orphaned comment
        $content = [regex]::Replace($content, '\s*<!--<< Nice Select\.css >>-->', '')
    }

    if ($content -ne $orig) {
        [System.IO.File]::WriteAllText($f.FullName, $content, $encNoBOM)
        $count = $removed.Count
        $totalRemoved += $count
        Write-Host "$($f.Name) - removed: $($removed -join ', ')"
    }
}
Write-Host "Total CSS removals: $totalRemoved"
