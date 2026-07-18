# Fix roc-compliance.html page title (86 rendered chars -> 61 chars)
$path = 'd:\Website Projects\Required Filings Website\required-filings\roc-compliance.html'
$enc  = [System.Text.Encoding]::UTF8
$encN = New-Object System.Text.UTF8Encoding $false

$old = 'ROC &amp; Corporate Compliance &mdash; Annual Filings, M&amp;A &amp; Corporate Law | RequiredFilings.com'
$new = 'ROC Compliance &amp; Annual Filing Services | RequiredFilings.com'

$content = [System.IO.File]::ReadAllText($path, $enc)
$updated = $content.Replace($old, $new)
if ($updated -ne $content) {
    [System.IO.File]::WriteAllText($path, $updated, $encN)
    Write-Host "Title updated - count: $([regex]::Matches($content, [regex]::Escape($old)).Count) replacements"
} else {
    Write-Host "String not found"
}
