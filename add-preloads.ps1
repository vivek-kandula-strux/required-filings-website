# Add resource preload hints to all 20 HTML pages
# - LCP image: hero-bg.jpg (index) or breadcrumb-bg.jpg (19 inner pages)
# - Critical font: fa-solid-900.woff2 (used above fold on all pages for nav/buttons)
$dir  = 'd:\Website Projects\Required Filings Website\required-filings'
$enc  = [System.Text.Encoding]::UTF8
$encN = New-Object System.Text.UTF8Encoding $false

# Insert point: right before the first <link rel="stylesheet"> in <head>
$cssAnchor = '<link rel="stylesheet" href="assets/css/bootstrap.min.css">'

$fontPreload = '        <link rel="preload" as="font" type="font/woff2" href="assets/webfonts/fa-solid-900.woff2" crossorigin>'

$heroPreload      = '        <link rel="preload" as="image" href="assets/img/home-1/hero/hero-bg.jpg" fetchpriority="high">'
$breadcrumbPreload = '        <link rel="preload" as="image" href="assets/img/breadcrumb-bg.jpg" fetchpriority="high">'

$pages = Get-ChildItem "$dir\*.html"
$count = 0

foreach ($f in $pages) {
    $content = [System.IO.File]::ReadAllText($f.FullName, $enc)

    # Skip if preloads already added
    if ($content -contains 'rel="preload"') { continue }
    if ($content -match 'rel="preload"') { continue }

    # Choose LCP image preload based on page
    $imgPreload = if ($f.BaseName -eq 'index') { $heroPreload } else { $breadcrumbPreload }

    $preloadBlock = "$imgPreload`n$fontPreload`n        "
    $new = $content -replace [regex]::Escape($cssAnchor), ($preloadBlock + $cssAnchor)

    if ($new -ne $content) {
        [System.IO.File]::WriteAllText($f.FullName, $new, $encN)
        $count++
        Write-Host "$($f.Name) - preloads added"
    } else {
        Write-Host "$($f.Name) - anchor not found, skipped"
    }
}
Write-Host "Done - $count pages updated"
