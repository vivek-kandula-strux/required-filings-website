# Add / update a ?v= querystring on the main.css link so browsers refetch after CSS edits.
# The .htaccess sends Cache-Control: immutable, max-age=1yr on CSS; the querystring is the bust knob.
# Update $version each time you change main.css.

$version = '2026-07-19-3'
$root = Join-Path $PSScriptRoot 'required-filings'
$files = Get-ChildItem -Path $root -Filter *.html -File

$encoding = New-Object System.Text.UTF8Encoding($false)
$hits = 0

foreach ($f in $files) {
    $text = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $orig = $text

    # Match the main.css link with or without an existing ?v= querystring.
    $text = [regex]::Replace(
        $text,
        'href="assets/css/main\.css(\?v=[^"]*)?"',
        ('href="assets/css/main.css?v={0}"' -f $version)
    )

    if ($text -ne $orig) {
        [System.IO.File]::WriteAllText($f.FullName, $text, $encoding)
        Write-Host ("bumped: {0}" -f $f.Name)
        $hits++
    }
}

Write-Host ("done - {0} file(s) updated to ?v={1}" -f $hits, $version)
