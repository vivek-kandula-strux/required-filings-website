# Remove magnific-popup JS and CSS from pages that no longer use it
$dir = 'd:\Website Projects\Required Filings Website\required-filings'
$enc = [System.Text.Encoding]::UTF8
$encNoBOM = New-Object System.Text.UTF8Encoding $false

$pages = @('index', 'about')
foreach ($p in $pages) {
    $path = "$dir\$p.html"
    $content = [System.IO.File]::ReadAllText($path, $enc)
    $new = [regex]::Replace($content, '\s*<script\s+src="assets/js/jquery\.magnific-popup\.min\.js"></script>', '')
    $new = [regex]::Replace($new, '\s*<link\s+rel="stylesheet"\s+href="assets/css/magnific-popup\.css">', '')
    if ($new -ne $content) {
        [System.IO.File]::WriteAllText($path, $new, $encNoBOM)
        Write-Host "Cleaned magnific from $p.html"
    }
}
Write-Host "Done"
