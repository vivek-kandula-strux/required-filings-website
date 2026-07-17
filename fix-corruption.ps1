# fix-corruption.ps1
# Removes the scriptblock-as-string corruption from all 20 HTML files.
# Three passes, each targeting a distinct suffix after the scriptblock text.

$enc    = [System.Text.Encoding]::UTF8
$outEnc = New-Object System.Text.UTF8Encoding $false

# The scriptblock text always starts with LF and ends with 4 spaces.
# The regex captures the N leading spaces on the same line (which were the
# indentation of the original </div> that got consumed).

$sb = '\n        param\(\$m\)\n        # This is too broad - let''s handle differently\n        \$m\.Value\n    '

# Pass 1 — acc-content current: scriptblock + " current">"
$pat1 = "(?m)^( *)$sb current`">"

# Pass 2 — acc-content (non-current): scriptblock + ">"
$pat2 = "(?m)^( *)$sb`">"

# Pass 3 — </div></li>: only the scriptblock (suffix is CR/LF or just LF)
$pat3 = "(?m)^( *)$sb"

$files = Get-ChildItem "required-filings\*.html"
$totalBefore = 0
$totalAfter  = 0

foreach ($file in $files) {
    $c = [System.IO.File]::ReadAllText($file.FullName, $enc)
    $before = ([regex]::Matches($c, 'param\(\$m\)')).Count
    if ($before -eq 0) { continue }
    $totalBefore += $before

    # Pass 1: restore </div> + <div class="acc-content current">
    $c = [regex]::Replace($c, $pat1, {
        param($m)
        $sp = $m.Groups[1].Value
        "$sp</div>`n$sp<div class=`"acc-content current`">"
    })

    # Pass 2: restore </div> + <div class="acc-content">
    $c = [regex]::Replace($c, $pat2, {
        param($m)
        $sp = $m.Groups[1].Value
        "$sp</div>`n$sp<div class=`"acc-content`">"
    })

    # Pass 3: restore </div> + </li>
    $c = [regex]::Replace($c, $pat3, {
        param($m)
        $sp = $m.Groups[1].Value
        $inner = ' ' * ([Math]::Max(0, $sp.Length - 4))
        "$sp</div>`n$inner</li>"
    })

    $after = ([regex]::Matches($c, 'param\(\$m\)')).Count
    $totalAfter += $after

    [System.IO.File]::WriteAllText($file.FullName, $c, $outEnc)
    Write-Host "$($file.Name): $before corruptions -> $after remaining"
}

Write-Host ""
Write-Host "Total before: $totalBefore  After: $totalAfter  Fixed: $($totalBefore - $totalAfter)"
