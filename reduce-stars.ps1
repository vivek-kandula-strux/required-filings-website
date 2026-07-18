# Reduces star decoration (star.svg in .sub-title) to <=30% of section headers.
# Strategy: keep on index.html (1st only), about.html (1st only), contact.html, services.html
# Remove from: service detail pages, legal pages, 404, blog
$dir = 'd:\Website Projects\Required Filings Website\required-filings'
$enc = [System.Text.Encoding]::UTF8
$encNoBOM = New-Object System.Text.UTF8Encoding $false

# Pages where ALL star instances are removed
$removeAll = @('gst-services','ipr','iso-certification','licenses','roc-compliance',
               'start-a-business','statutory-registrations','tax-services',
               'privacy','terms','refund','disclaimer','404','blog')

# Star img pattern
$starPattern = '\s*<img src="assets/img/home-1/star\.svg"[^>]+>\s*'

foreach ($page in $removeAll) {
    $path = "$dir\$page.html"
    $content = [System.IO.File]::ReadAllText($path, $enc)
    $new = [regex]::Replace($content, $starPattern, ' ')
    if ($new -ne $content) {
        [System.IO.File]::WriteAllText($path, $new, $encNoBOM)
        Write-Host "Removed all stars from $page.html"
    }
}

# index.html: keep 1st star, remove remaining 3
$path = "$dir\index.html"
$content = [System.IO.File]::ReadAllText($path, $enc)
$firstDone = $false
$new = [regex]::Replace($content, $starPattern, {
    param($m)
    if (-not $firstDone) {
        $script:firstDone = $true
        return $m.Value  # keep first
    }
    return ' '  # remove rest
})
if ($new -ne $content) {
    [System.IO.File]::WriteAllText($path, $new, $encNoBOM)
    Write-Host "index.html: kept 1 star, removed rest"
}

# about.html: keep 1st star, remove remaining 2
$path = "$dir\about.html"
$content = [System.IO.File]::ReadAllText($path, $enc)
$firstDone = $false
$new = [regex]::Replace($content, $starPattern, {
    param($m)
    if (-not $firstDone) {
        $script:firstDone = $true
        return $m.Value
    }
    return ' '
})
if ($new -ne $content) {
    [System.IO.File]::WriteAllText($path, $new, $encNoBOM)
    Write-Host "about.html: kept 1 star, removed rest"
}

Write-Host "Done"
