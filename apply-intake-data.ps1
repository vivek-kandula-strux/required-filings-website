# Applies the filled values from client-intake-checklist.docx to every page.
# Safe UTF-8 round-trip (read UTF-8, write UTF-8-no-BOM) to avoid em-dash mojibake.

$root = 'd:\Website Projects\Required Filings Website\required-filings'
$htmls = Get-ChildItem $root -Filter *.html -File
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# --- Confirmed values from intake ---
$phoneE164  = '+919502715353'
$phoneVisible = '+91 95027 15353'
$waNumber   = '919502715353'        # for wa.me URL
$waVisible  = '+91 95027 15353'
$email      = 'srivaarahi.gst@srivaarahi.com'
$address    = '1-3-183/40/A/B, Flat-101, Plot No-34, Udaya Aditya Apts, Gandhinagar, Hyderabad &mdash; 500080'
$addressOneLine = '1-3-183/40/A/B, Flat-101, Plot No-34, Udaya Aditya Apts, Gandhinagar, Hyderabad &mdash; 500080'
$city       = 'Hyderabad'
$entity     = 'Sri Vaarahi Computer Services Pvt. Ltd.'
$founder    = 'Neelambar Vadrevu'
$founded    = '2017'
$gstin      = '36AAYCS9154Q1ZZ'
$cin        = 'U72900TG2017PTC118162'
$hoursLine  = 'Mon&ndash;Sat, 10:00&ndash;18:00 IST'

# --- Site-wide string replacements (literal, simple) ---
$replacements = @(
    # Phone (tel: href)
    @{ find = 'tel:[TBD-phone]';                                 replace = "tel:$phoneE164" }
    # Phone (visible label)
    @{ find = '[TBD: +91 phone]';                                replace = $phoneVisible }
    # Email (mailto:)
    @{ find = 'mailto:[TBD-email]';                              replace = "mailto:$email" }
    # Email (visible label)
    @{ find = '[TBD: hello@requiredfilings.com]';                replace = $email }
    # Email used inside form-error message
    @{ find = '[TBD-email]';                                     replace = $email }
    # Office address followed by ", India"
    @{ find = '[TBD: office address], India';                    replace = "$addressOneLine, India" }
    # Office address (other occurrences)
    @{ find = '[TBD: office address]';                           replace = $addressOneLine }
    # Registered office address (Privacy / Terms)
    @{ find = '[TBD: registered office address]';                replace = $addressOneLine }
    # Jurisdiction city in Terms
    @{ find = '[TBD: city of registered office]';                replace = $city }
    # Legal entity name
    @{ find = '[TBD: legal entity name]';                        replace = $entity }
    # Founder name
    @{ find = '[TBD: founder name]';                             replace = $founder }
    # Year founded
    @{ find = '[TBD: year founded]';                             replace = $founded }
    # GSTIN line (footer)
    @{ find = 'GSTIN: [TBD]';                                    replace = "GSTIN: $gstin" }
    # CIN line (terms.html)
    @{ find = 'CIN/Firm reg: [TBD]';                             replace = "CIN: $cin" }
    # Working hours (old 19:00 closing -> new 18:00 closing)
    @{ find = 'Mon&ndash;Sat, 10:00&ndash;19:00 IST';            replace = $hoursLine }
)

$changed = 0
foreach ($h in $htmls) {
    $c = [System.IO.File]::ReadAllText($h.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c
    foreach ($r in $replacements) {
        $c = $c.Replace($r.find, $r.replace)
    }
    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        $changed++
        Write-Host "Updated: $($h.Name)"
    }
}
Write-Host "Total files updated: $changed"
