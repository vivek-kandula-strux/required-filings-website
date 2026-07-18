# Check all internal href links (non-external, non-anchor, non-tel/mailto)
# Reports any link targets that don't exist as files in required-filings/
$dir = 'd:\Website Projects\Required Filings Website\required-filings'
$enc = [System.Text.Encoding]::UTF8
$broken = @()

foreach ($f in Get-ChildItem "$dir\*.html") {
    $content = [System.IO.File]::ReadAllText($f.FullName, $enc)
    # Find all href values
    $matches = [regex]::Matches($content, 'href="([^"#?]+\.html(?:[^"]*)?)"')
    foreach ($m in $matches) {
        $href = $m.Groups[1].Value
        # Skip external URLs
        if ($href -match '^https?://') { continue }
        # Strip query string or hash
        $file = $href -replace '[?#].*', ''
        $full = Join-Path $dir $file
        if (-not (Test-Path $full)) {
            $broken += "$($f.Name) -> $href"
        }
    }
}

if ($broken.Count -eq 0) {
    Write-Host "No broken internal HTML links found."
} else {
    Write-Host "BROKEN LINKS:"
    $broken | ForEach-Object { Write-Host "  $_" }
}

# Also check CSS/JS/image src references that are local
$assetBroken = @()
foreach ($f in Get-ChildItem "$dir\*.html") {
    $content = [System.IO.File]::ReadAllText($f.FullName, $enc)
    $refs = [regex]::Matches($content, '(?:href|src)="(assets/[^"]+)"')
    foreach ($m in $refs) {
        $path = Join-Path $dir $m.Groups[1].Value
        if (-not (Test-Path $path)) {
            $assetBroken += "$($f.Name) -> $($m.Groups[1].Value)"
        }
    }
}
if ($assetBroken.Count -eq 0) {
    Write-Host "No broken asset references (CSS/JS/images) found."
} else {
    Write-Host "BROKEN ASSETS:"
    $assetBroken | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }
}
