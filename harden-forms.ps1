$root = 'd:\Website Projects\Required Filings Website\required-filings'
$htmls = Get-ChildItem $root -Filter *.html -File
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Inline .visually-hidden style block (injected once into <head>)
$styleBlock = @'
        <!-- RF form helpers -->
        <style>.visually-hidden{position:absolute!important;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}.rf-form-msg{margin-top:1rem;padding:1rem 1.25rem;border-radius:6px;font-size:.95rem}.rf-form-success{background:#e8f7ee;color:#0e6b3a;border:1px solid #0e6b3a33}.rf-form-error{background:#fdecec;color:#a8232a;border:1px solid #a8232a33}</style>
'@

# Honeypot HTML (injected inside form, just before the submit-button column)
$honeypot = @'
                                                <div class="visually-hidden" aria-hidden="true">
                                                    <label for="cf-website">Leave this field blank</label>
                                                    <input type="text" id="cf-website" name="cf_website" tabindex="-1" autocomplete="off">
                                                </div>
'@

# Success / error containers (injected after the submit-button column)
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

    # 1) Inject style block once per page (right before </head>)
    if ($c -notmatch 'RF form helpers') {
        $c = $c -replace '(\s*)</head>', ($styleBlock + "`r`n$1</head>")
    }

    # 2) Upgrade <form action="contact.php" id="contact-form" ...> to real endpoint, POST, novalidate
    $c = $c -replace '<form action="contact\.php" id="contact-form" class="contact-form-box">', '<form action="[TBD-form-endpoint]" method="POST" id="contact-form" class="contact-form-box" novalidate>'

    # 3) Add name attribute where missing on text/email/tel inputs (ISO page case)
    $c = $c -replace '<input type="text" placeholder="Your full name">',  '<input type="text" name="name" placeholder="Your full name">'
    $c = $c -replace '<input type="email" placeholder="Your work email">', '<input type="email" name="email" placeholder="Your work email">'
    $c = $c -replace '<input type="tel" placeholder="Your phone with country code">', '<input type="tel" name="phone" placeholder="Your phone with country code">'
    $c = $c -replace '<select class="single-select w-100">', '<select class="single-select w-100" name="service">'

    # 4) Add label + id + required on each input variant
    # 4a) full_name / name (text)
    $c = [regex]::Replace($c, '<input type="text" name="(full_name|name)" placeholder="([^"]+)">', {
        param($m)
        $nm = $m.Groups[1].Value; $ph = $m.Groups[2].Value
        '<label for="cf-name" class="visually-hidden">Your full name</label><input type="text" id="cf-name" name="' + $nm + '" placeholder="' + $ph + '" autocomplete="name" required minlength="2" maxlength="80">'
    })

    # 4b) email
    $c = [regex]::Replace($c, '<input type="email" name="email" placeholder="([^"]+)">', {
        param($m)
        $ph = $m.Groups[1].Value
        '<label for="cf-email" class="visually-hidden">Your work email</label><input type="email" id="cf-email" name="email" placeholder="' + $ph + '" autocomplete="email" required maxlength="120">'
    })

    # 4c) tel
    $c = [regex]::Replace($c, '<input type="tel" name="phone" placeholder="([^"]+)">', {
        param($m)
        $ph = $m.Groups[1].Value
        '<label for="cf-phone" class="visually-hidden">Your phone number</label><input type="tel" id="cf-phone" name="phone" placeholder="' + $ph + '" autocomplete="tel" required pattern="[0-9+\-\s()]{7,20}" maxlength="20">'
    })

    # 4d) service select
    $c = $c -replace '<select class="single-select w-100" name="service">', '<select class="single-select w-100" id="cf-service" name="service" required>'

    # 4e) textarea
    $c = [regex]::Replace($c, '<textarea name="message" placeholder="([^"]+)"></textarea>', {
        param($m)
        $ph = $m.Groups[1].Value
        '<label for="cf-message" class="visually-hidden">Your message</label><textarea id="cf-message" name="message" placeholder="' + $ph + '" required minlength="10" maxlength="1500" rows="5"></textarea>'
    })

    # 5) Inject honeypot just before the submit-button column,
    #    and inject success/error containers just after the submit column.
    #    The submit column starts with col-lg-12 wow fadeInUp .5s wrapping the button.
    $submitPattern = '(<div class="col-lg-12 wow fadeInUp" data-wow-delay="\.5s">\s*<button type="submit")'
    if ($c -match $submitPattern -and $c -notmatch 'cf-website') {
        $c = [regex]::Replace($c, $submitPattern, ($honeypot + "`r`n                                                <div class=`"col-lg-12 wow fadeInUp`" data-wow-delay=`".5s`">`r`n                                                    <button type=`"submit`""), 1)
    }
    # After the submit column closes (</div> after </button>), append message containers (only once per form)
    if ($c -notmatch 'rf-form-success' -and $c -match '<button type="submit"') {
        # Find the </button>...</div> pattern that closes the submit col, and insert messages after it
        $c = [regex]::Replace($c, '(</button>\s*</div>)(\s*</div>\s*</form>)', ('$1' + "`r`n" + $messages + '$2'), 1)
    }

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        $changed++
        Write-Host "Hardened: $($h.Name)"
    }
}

Write-Host "Total files hardened: $changed"
