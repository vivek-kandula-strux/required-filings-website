# Removes unused JS scripts from content pages (Phase 12.1/12.2)
# Legal/404 pages were already trimmed in Phase 15.
# Run: powershell -ExecutionPolicy Bypass -File .\trim-scripts.ps1

$dir = 'd:\Website Projects\Required Filings Website\required-filings'
$enc = [System.Text.Encoding]::UTF8
$encNoBOM = New-Object System.Text.UTF8Encoding $false

# Scripts absolutely unused on every content page
$alwaysRemove = @(
    'assets/js/viewport.jquery.js',
    'assets/js/ScrollToPlugin.min.js',
    'assets/js/TextPlugin.js',
    'assets/js/chroma.min.js',
    'assets/js/parallaxie.js'
)

# Pages with .single-select (keep nice-select)
$hasNiceSelect = @('start-a-business','contact','gst-services','services','ipr','iso-certification','roc-compliance','tax-services','statutory-registrations','licenses')

# Pages with swiper-slide (keep swiper)
$hasSwiper = @('index')

# Pages with magnific popup classes (keep magnific)
$hasMagnific = @('about','index')

# Pages with .count class (keep counterup + waypoints)
$hasCounter = @('about')

$allPages = @('index','about','contact','services','blog',
    'start-a-business','gst-services','tax-services','roc-compliance','ipr',
    'iso-certification','msme-zed','accounting','statutory-registrations','licenses')

function Remove-ScriptTag($content, $src) {
    # Match the exact script tag line (with optional whitespace)
    $escaped = [regex]::Escape($src)
    $pattern = '\s*<script\s+src="' + $escaped + '"></script>'
    return [regex]::Replace($content, $pattern, '')
}

$totalRemoved = 0

foreach ($page in $allPages) {
    $path = "$dir\$page.html"
    $content = [System.IO.File]::ReadAllText($path, $enc)
    $original = $content
    $removed = @()

    # Always remove these 5
    foreach ($s in $alwaysRemove) {
        $before = $content
        $content = Remove-ScriptTag $content $s
        if ($content -ne $before) { $removed += $s }
    }

    # Remove swiper if page doesn't use it
    if ($hasSwiper -notcontains $page) {
        $before = $content
        $content = Remove-ScriptTag $content 'assets/js/swiper-bundle.min.js'
        if ($content -ne $before) { $removed += 'swiper-bundle.min.js' }
    }

    # Remove magnific if page doesn't use it
    if ($hasMagnific -notcontains $page) {
        $before = $content
        $content = Remove-ScriptTag $content 'assets/js/jquery.magnific-popup.min.js'
        if ($content -ne $before) { $removed += 'magnific-popup.min.js' }
    }

    # Remove counterup + waypoints if page doesn't use them
    if ($hasCounter -notcontains $page) {
        $before = $content
        $content = Remove-ScriptTag $content 'assets/js/jquery.counterup.min.js'
        if ($content -ne $before) { $removed += 'counterup.min.js' }
        $before = $content
        $content = Remove-ScriptTag $content 'assets/js/jquery.waypoints.js'
        if ($content -ne $before) { $removed += 'waypoints.js' }
    }

    # Remove nice-select if page doesn't use it
    if ($hasNiceSelect -notcontains $page) {
        $before = $content
        $content = Remove-ScriptTag $content 'assets/js/jquery.nice-select.min.js'
        if ($content -ne $before) { $removed += 'nice-select.min.js' }
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $encNoBOM)
        $count = $removed.Count
        $totalRemoved += $count
        Write-Host "$page.html — removed $count scripts: $($removed -join ', ')"
    } else {
        Write-Host "$page.html — no changes"
    }
}

Write-Host ""
Write-Host "Done. Total script tag removals: $totalRemoved"
