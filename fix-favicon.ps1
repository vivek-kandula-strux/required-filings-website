# Modernise favicon link on all 20 pages
# rel="shortcut icon" -> rel="icon" type="image/svg+xml"
$dir  = 'd:\Website Projects\Required Filings Website\required-filings'
$enc  = [System.Text.Encoding]::UTF8
$encN = New-Object System.Text.UTF8Encoding $false

$old = '<link rel="shortcut icon" href="assets/img/favicon.svg">'
$new = '<link rel="icon" href="assets/img/favicon.svg" type="image/svg+xml">'

$count = 0
foreach ($f in Get-ChildItem "$dir\*.html") {
    $content = [System.IO.File]::ReadAllText($f.FullName, $enc)
    if ($content -match [regex]::Escape($old)) {
        $updated = $content.Replace($old, $new)
        if ($updated -ne $content) {
            [System.IO.File]::WriteAllText($f.FullName, $updated, $encN)
            $count++
        }
    }
}
Write-Host "Favicon updated on $count pages"
