# Second pass: fix remaining tokens after the first replacement.
# - Plain [TBD-phone] inside form-error messages
# - Team-member names on about.html (4 slots)
# - Testimonial placeholders on homepage (3 slots) and about (5 slots)
# - Blog post dates (6 on blog.html + 3 on homepage news cards)
# - Map embed iframe on contact.html

$root = 'd:\Website Projects\Required Filings Website\required-filings'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$htmls = Get-ChildItem $root -Filter *.html -File

$phoneVisible = '+91 95027 15353'

# Build the testimonial placeholders.
# Body: short message; name; type-and-city.
$testiBody = 'Client stories are published only after we have written permission. We are collecting these from clients we have worked with since 2017. New testimonials publish here in the weeks ahead.'
$testiName = 'Coming soon'
$testiType = 'Real client stories pending'

# Google Maps embed URL (legacy q= form — works without an API key; user can swap when they
# generate a custom embed from Google Business Profile.)
$mapEmbed = 'https://maps.google.com/maps?q=1-3-183%2F40%2FA%2FB%2C+Flat-101%2C+Plot+No-34%2C+Udaya+Aditya+Apts%2C+Gandhinagar%2C+Hyderabad+500080&hl=en&z=16&output=embed'

# Blog dates — staggered around the launch window
$blogDates = @('15 Jul 2026', '22 Jul 2026', '29 Jul 2026', '05 Aug 2026', '12 Aug 2026', '19 Aug 2026')
$newsDates = @('15 Jul 2026', '22 Jul 2026', '29 Jul 2026')

$changed = 0

# --- contact.html: form-error [TBD-phone] + map iframe ---
$contactPath = Join-Path $root 'contact.html'
$c = [System.IO.File]::ReadAllText($contactPath, [System.Text.Encoding]::UTF8)
$orig = $c
$c = $c.Replace('or call [TBD-phone].', "or call $phoneVisible.")
$c = $c -replace '<iframe src="\[TBD-map-embed\]"', "<iframe src=`"$mapEmbed`""
if ($c -ne $orig) {
    [System.IO.File]::WriteAllText($contactPath, $c, $utf8NoBom)
    Write-Host "Patched contact.html (form-error phone + map embed)"
    $changed++
}

# --- All HTMLs: form-error [TBD-phone] cleanup (covers the 10 service-page forms) ---
foreach ($h in $htmls) {
    $c = [System.IO.File]::ReadAllText($h.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c
    $c = $c.Replace('or call [TBD-phone].', "or call $phoneVisible.")
    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        Write-Host "Form-error phone fixed: $($h.Name)"
        $changed++
    }
}

# --- index.html: replace 3 testimonial slides ---
$indexPath = Join-Path $root 'index.html'
$c = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8)
$orig = $c
$c = $c.Replace('[TBD: Real client testimonial pending. Per content principles, trust is built through specificity &mdash; placeholder will be replaced before launch.]', $testiBody)
$c = $c.Replace('[TBD: Client name]', $testiName)
$c = $c.Replace('[TBD: Business type and city]', $testiType)
# Blog dates on homepage news cards
$dateCount = 0
$c = [regex]::Replace($c, '<span>\[TBD: date\]</span>', {
    param($m)
    $script:dateCount++
    if ($script:dateCount -le $newsDates.Length) { return '<span>' + $newsDates[$script:dateCount - 1] + '</span>' }
    return '<span>' + $newsDates[$newsDates.Length - 1] + '</span>'
})
if ($c -ne $orig) {
    [System.IO.File]::WriteAllText($indexPath, $c, $utf8NoBom)
    Write-Host "Index: testimonials + news dates patched"
    $changed++
}

# --- about.html: testimonials, team-member names ---
$aboutPath = Join-Path $root 'about.html'
$c = [System.IO.File]::ReadAllText($aboutPath, [System.Text.Encoding]::UTF8)
$orig = $c
$c = $c.Replace('[TBD: Real client testimonial pending. Per content principles, trust is built through specificity &mdash; placeholder will be replaced before launch.]', $testiBody)
$c = $c.Replace('[TBD: Client name]', $testiName)
$c = $c.Replace('[TBD: Business type and city]', $testiType)

# Team members — only slot 1 (Neelambar) and slot 2 (Radhika) have confirmed names.
# Slot 1 is the first occurrence, slot 2 the second, etc.
$slotNames = @(
    'Neelambar Vadrevu',
    'Radhika Vadrevu',
    'Profile updating soon',
    'Profile updating soon'
)
$slotIdx = 0
$c = [regex]::Replace($c, '<a href="contact\.html">\[TBD: Team member name\]</a>', {
    param($m)
    $nm = $slotNames[$script:slotIdx]
    $script:slotIdx++
    return '<a href="contact.html">' + $nm + '</a>'
})

# Slot 1's role is currently "Founder & Chartered Accountant" — change to the role
# confirmed in the intake sign-off ("Managing director").
$c = $c.Replace('Founder &amp; Chartered Accountant', 'Founder &amp; Managing Director')

if ($c -ne $orig) {
    [System.IO.File]::WriteAllText($aboutPath, $c, $utf8NoBom)
    Write-Host "About: testimonials + team slots patched"
    $changed++
}

# --- blog.html: 6 article dates ---
$blogPath = Join-Path $root 'blog.html'
$c = [System.IO.File]::ReadAllText($blogPath, [System.Text.Encoding]::UTF8)
$orig = $c
$bIdx = 0
$c = [regex]::Replace($c, '<span>\[TBD: date\]</span>', {
    param($m)
    if ($script:bIdx -lt $blogDates.Length) {
        $d = $blogDates[$script:bIdx]
    } else {
        $d = $blogDates[$blogDates.Length - 1]
    }
    $script:bIdx++
    return '<span>' + $d + '</span>'
})
if ($c -ne $orig) {
    [System.IO.File]::WriteAllText($blogPath, $c, $utf8NoBom)
    Write-Host "Blog dates patched"
    $changed++
}

Write-Host "Total file-writes: $changed"
