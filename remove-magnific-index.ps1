$path = 'd:\Website Projects\Required Filings Website\required-filings\index.html'
$enc = [System.Text.Encoding]::UTF8
$encNoBOM = New-Object System.Text.UTF8Encoding $false
$content = [System.IO.File]::ReadAllText($path, $enc)
$new = [regex]::Replace($content, '\s*<script\s+src="assets/js/jquery\.magnific-popup\.min\.js"></script>', '')
if ($new -ne $content) {
    [System.IO.File]::WriteAllText($path, $new, $encNoBOM)
    Write-Host "Removed magnific-popup from index.html"
} else {
    Write-Host "Not found"
}
