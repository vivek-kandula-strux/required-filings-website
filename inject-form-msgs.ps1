$root = 'd:\Website Projects\Required Filings Website\required-filings'
$htmls = Get-ChildItem $root -Filter *.html -File
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$messages = @'
                                                <div class="col-lg-12">
                                                    <div class="rf-form-msg rf-form-success" role="status" aria-live="polite" hidden>Thanks. A real person will reply within one working day.</div>
                                                    <div class="rf-form-msg rf-form-error" role="alert" aria-live="assertive" hidden>Something went wrong. Please email [TBD-email] or call [TBD-phone].</div>
                                                </div>
'@

$changed = 0
foreach ($h in $htmls) {
    $c = [System.IO.File]::ReadAllText($h.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c
    # Only operate on files that have a contact form (action="[TBD-form-endpoint]") AND don't already have rf-form-msg div
    if ($c -match 'action="\[TBD-form-endpoint\]"' -and $c -notmatch '<div class="rf-form-msg') {
        $c = [regex]::Replace($c, '(</button>\s*</div>)(\s*</div>\s*</form>)', ('$1' + "`r`n" + $messages + '$2'), 1)
    }
    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        $changed++
        Write-Host "Messages injected: $($h.Name)"
    }
}
Write-Host "Total: $changed"
