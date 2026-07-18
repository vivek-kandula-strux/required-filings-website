# Removes ScrollSmoother.min.js from all 20 HTML pages (confirmed dead code — main.js
# guard checks for #smooth-wrapper which no page has; rf-scroll-wrapper uses native scroll)
$dir = 'd:\Website Projects\Required Filings Website\required-filings'
$enc = [System.Text.Encoding]::UTF8
$encNoBOM = New-Object System.Text.UTF8Encoding $false

$pages = Get-ChildItem "$dir\*.html"
$count = 0
foreach ($f in $pages) {
    $content = [System.IO.File]::ReadAllText($f.FullName, $enc)
    $new = [regex]::Replace($content, '\s*<script\s+src="assets/js/ScrollSmoother\.min\.js"></script>', '')
    if ($new -ne $content) {
        [System.IO.File]::WriteAllText($f.FullName, $new, $encNoBOM)
        Write-Host "Removed from $($f.Name)"
        $count++
    }
}
Write-Host "Done - removed from $count pages"
