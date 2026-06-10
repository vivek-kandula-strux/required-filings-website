$root = 'd:\Website Projects\Required Filings Website\required-filings'
$htmls = Get-ChildItem $root -Filter *.html -File

# Mojibake mapping: corrupted UTF-8 sequence -> correct character
$fixes = @(
    @{ bad = [char]0x00E2 + [char]0x20AC + [char]0x201D; good = [char]0x2014 },   # em-dash —
    @{ bad = [char]0x00E2 + [char]0x20AC + [char]0x201C; good = [char]0x2013 },   # en-dash –
    @{ bad = [char]0x00E2 + [char]0x20AC + [char]0x02DC; good = [char]0x2018 },   # left single quote '
    @{ bad = [char]0x00E2 + [char]0x20AC + [char]0x2122; good = [char]0x2019 },   # right single quote '
    @{ bad = [char]0x00E2 + [char]0x20AC + [char]0x0153; good = [char]0x201C },   # left double quote "
    @{ bad = [char]0x00E2 + [char]0x20AC + [char]0x009D; good = [char]0x201D },   # right double quote "
    @{ bad = [char]0x00E2 + [char]0x20AC + [char]0x00A6; good = [char]0x2026 },   # ellipsis …
    @{ bad = [char]0x00E2 + [char]0x201A + [char]0x00B9; good = [char]0x20B9 },   # rupee ₹
    @{ bad = [char]0x00E2 + [char]0x201A + [char]0x00AC; good = [char]0x20AC },   # euro €
    @{ bad = [char]0x00C3 + [char]0x00A9; good = [char]0x00E9 },                  # é
    @{ bad = [char]0x00C3 + [char]0x00A8; good = [char]0x00E8 },                  # è
    @{ bad = [char]0x00C2 + [char]0x00A9; good = [char]0x00A9 },                  # © copyright
    @{ bad = [char]0x00C2 + [char]0x00AE; good = [char]0x00AE },                  # ® registered
    @{ bad = [char]0x00C2 + [char]0x00B7; good = [char]0x00B7 },                  # · middle dot
    @{ bad = [char]0x00C2 + [char]0x00A0; good = [char]0x00A0 }                   # nbsp
)

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

foreach ($h in $htmls) {
    $c = [System.IO.File]::ReadAllText($h.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c
    foreach ($f in $fixes) {
        $c = $c.Replace($f.bad, $f.good)
    }
    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        Write-Host "Fixed: $($h.Name)"
    } else {
        Write-Host "Clean: $($h.Name)"
    }
}
