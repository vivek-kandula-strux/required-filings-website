# Add data-success-message to newsletter form on all 20 pages
$dir  = 'd:\Website Projects\Required Filings Website\required-filings'
$enc  = [System.Text.Encoding]::UTF8
$encN = New-Object System.Text.UTF8Encoding $false

$old = 'id="newsletter-form"'
$new = 'id="newsletter-form" data-success-message="Subscribed! Your first deadline alert will arrive within a month."'

$count = 0
foreach ($f in Get-ChildItem "$dir\*.html") {
    $content = [System.IO.File]::ReadAllText($f.FullName, $enc)
    if ($content -match [regex]::Escape($old)) {
        $updated = $content.Replace($old, $new)
        if ($updated -ne $content) {
            [System.IO.File]::WriteAllText($f.FullName, $updated, $encN)
            $count++
            Write-Host "$($f.Name) - updated"
        }
    }
}
Write-Host "Done - $count pages updated"
