$dir = 'd:\Website Projects\Required Filings Website\required-filings'
$enc = [System.Text.Encoding]::UTF8
$pages = Get-ChildItem "$dir\*.html"

$totalSubtitle = 0
$totalStars = 0

foreach ($p in $pages) {
    $content = [System.IO.File]::ReadAllText($p.FullName, $enc)
    $subtitles = ([regex]::Matches($content, 'class="sub-title')).Count
    $stars = ([regex]::Matches($content, 'star\.svg')).Count
    if ($subtitles -gt 0) {
        $totalSubtitle += $subtitles
        $totalStars += $stars
        Write-Host "$($p.Name): $subtitles sub-titles, $stars stars"
    }
}

Write-Host ""
Write-Host "Total: $totalSubtitle sub-titles, $totalStars with star = $([math]::Round($totalStars/$totalSubtitle*100))%"
