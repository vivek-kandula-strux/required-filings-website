# Adds a WhatsApp click-to-chat link to the offcanvas contact list and footer
# "Get in touch" list on every page. WhatsApp number per intake: +91 9502715353.

$root = 'd:\Website Projects\Required Filings Website\required-filings'
$htmls = Get-ChildItem $root -Filter *.html -File
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$waUrl = 'https://wa.me/919502715353'
$waVisible = '+91 95027 15353'

# Offcanvas: insert a 5th li right after the phone li (which contains <a href="tel:+919502715353">).
# Match the entire phone li block, then append a sibling WhatsApp li.
$offcanvasPhonePattern = @'
                                    <li class="d-flex align-items-center">
                                        <div class="offcanvas__contact-icon mr-15">
                                            <i class="far fa-phone"></i>
                                        </div>
                                        <div class="offcanvas__contact-text">
                                            <a href="tel:+919502715353">+91 95027 15353</a>
                                        </div>
                                    </li>
'@

$offcanvasPhoneReplace = $offcanvasPhonePattern + @'
                                    <li class="d-flex align-items-center">
                                        <div class="offcanvas__contact-icon mr-15">
                                            <i class="fab fa-whatsapp"></i>
                                        </div>
                                        <div class="offcanvas__contact-text">
                                            <a href="https://wa.me/919502715353" target="_blank" rel="noopener">WhatsApp chat</a>
                                        </div>
                                    </li>
'@

# Some pages have slightly different (shallower) indentation for the offcanvas (about.html style).
# Match by a more flexible regex that captures the indent.
$offcanvasRegex = '(?s)(\s*)<li class="d-flex align-items-center">\s*<div class="offcanvas__contact-icon mr-15">\s*<i class="far fa-phone"></i>\s*</div>\s*<div class="offcanvas__contact-text">\s*<a href="tel:\+919502715353">\+91 95027 15353</a>\s*</div>\s*</li>'

$footerPhoneRegex = '(?s)(\s+)(<li>\s*<a href="tel:\+919502715353">\+91 95027 15353</a>\s*</li>)'

$changed = 0
foreach ($h in $htmls) {
    $c = [System.IO.File]::ReadAllText($h.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c

    # 1) Offcanvas — only insert if not already present
    if ($c -notmatch 'fab fa-whatsapp') {
        $c = [regex]::Replace($c, $offcanvasRegex, {
            param($m)
            $indent = $m.Groups[1].Value
            $original = $m.Value
            $waLi = $indent + '<li class="d-flex align-items-center">' + "`r`n" `
                  + $indent + '    <div class="offcanvas__contact-icon mr-15">' + "`r`n" `
                  + $indent + '        <i class="fab fa-whatsapp"></i>' + "`r`n" `
                  + $indent + '    </div>' + "`r`n" `
                  + $indent + '    <div class="offcanvas__contact-text">' + "`r`n" `
                  + $indent + '        <a href="https://wa.me/919502715353" target="_blank" rel="noopener">WhatsApp chat</a>' + "`r`n" `
                  + $indent + '    </div>' + "`r`n" `
                  + $indent + '</li>'
            return $original + $waLi
        }, 1)
    }

    # 2) Footer "Get in touch" list — insert WhatsApp li immediately after phone li
    if ($c -notmatch 'wa\.me/919502715353"\s*>WhatsApp') {
        $c = [regex]::Replace($c, $footerPhoneRegex, {
            param($m)
            $indent = $m.Groups[1].Value
            $orig = $m.Value
            $waLi = $indent + '<li>' + "`r`n" `
                  + $indent + '    <a href="https://wa.me/919502715353" target="_blank" rel="noopener">WhatsApp: ' + $waVisible + '</a>' + "`r`n" `
                  + $indent.TrimStart("`r","`n") + '</li>'
            # Simpler: just append a sibling li in the same indent
            $simpleLi = $indent + '<li><a href="https://wa.me/919502715353" target="_blank" rel="noopener">WhatsApp: ' + $waVisible + '</a></li>'
            return $orig + $simpleLi
        }, 1)
    }

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        $changed++
        Write-Host "WhatsApp added: $($h.Name)"
    }
}
Write-Host "Total files updated: $changed"
