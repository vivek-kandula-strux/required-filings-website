$root = 'd:\Website Projects\Required Filings Website\required-filings'
$htmls = Get-ChildItem $root -Filter *.html -File

# Map: filename pattern (regex) -> alt text
# Order matters — first match wins
$altMap = @(
    @{ pattern = 'assets/img/home-1/hero/light-bg\.png';        alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/hero/hero-bg\.jpg';         alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/hero/hero-1\.png';          alt = 'Compliance and filings dashboard preview' },
    @{ pattern = 'assets/img/home-1/hero/box1\.png';            alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/hero/box2\.png';            alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/hero/client-img\.png';      alt = 'Clients served' },
    @{ pattern = 'assets/img/home-1/about/about-image\.jpg';    alt = 'RequiredFilings team at work' },
    @{ pattern = 'assets/img/home-1/about/about-video\.jpg';    alt = 'RequiredFilings introduction video' },
    @{ pattern = 'assets/img/home-1/faq-image\.jpg';            alt = 'How RequiredFilings works' },
    @{ pattern = 'assets/img/home-1/increase\.png';             alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/cta-newsletter\.jpg';       alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/icon/icon1\.svg';           alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/icon/icon2\.svg';           alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/icon/icon3\.svg';           alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/icon/icon4\.svg';           alt = ''; decorative = $true },
    @{ pattern = 'assets/img/home-1/brand/brand-1\.png';        alt = 'Client logo' },
    @{ pattern = 'assets/img/home-1/brand/brand-2\.png';        alt = 'Client logo' },
    @{ pattern = 'assets/img/home-1/brand/brand-3\.png';        alt = 'Client logo' },
    @{ pattern = 'assets/img/home-1/brand/brand-4\.png';        alt = 'Client logo' },
    @{ pattern = 'assets/img/home-1/brand/brand-5\.png';        alt = 'Client logo' },
    @{ pattern = 'assets/img/home-1/brand/brand-6\.png';        alt = 'Client logo' },
    @{ pattern = 'assets/img/home-1/news/news-01\.jpg';         alt = 'GST registration article' },
    @{ pattern = 'assets/img/home-1/news/news-02\.jpg';         alt = 'ROC annual filing article' },
    @{ pattern = 'assets/img/home-1/news/news-03\.jpg';         alt = 'Pvt Ltd vs LLP article' },
    @{ pattern = 'assets/img/home-1/news/news-04\.jpg';         alt = 'Filing guide article' },
    @{ pattern = 'assets/img/home-1/news/news-05\.jpg';         alt = 'Filing guide article' },
    @{ pattern = 'assets/img/home-1/news/news-06\.jpg';         alt = 'Filing guide article' },
    @{ pattern = 'assets/img/home-1/project/project-1\.jpg';    alt = 'SaaS startup filing case' },
    @{ pattern = 'assets/img/home-1/project/project-2\.jpg';    alt = 'Trader GST recovery case' },
    @{ pattern = 'assets/img/home-1/project/project-3\.jpg';    alt = 'Manufacturer ISO certification case' },
    @{ pattern = 'assets/img/home-1/testimonial/client-1\.png'; alt = 'Client portrait' },
    @{ pattern = 'assets/img/home-1/testimonial/client-2\.png'; alt = 'Client portrait' },
    @{ pattern = 'assets/img/home-1/testimonial/client-3\.png'; alt = 'Client portrait' },
    @{ pattern = 'assets/img/home-3/client-info\.png';          alt = 'Client portrait' },
    @{ pattern = 'assets/img/home-3/client-info-2\.png';        alt = 'Client portrait' },
    @{ pattern = 'assets/img/home-3/client-info-3\.png';        alt = 'Client portrait' },
    @{ pattern = 'assets/img/home-3/client-info-4\.png';        alt = 'Client portrait' },
    @{ pattern = 'assets/img/home-3/client-info-5\.png';        alt = 'Client portrait' },
    @{ pattern = 'assets/img/breadcrumb-bg\.jpg';               alt = ''; decorative = $true },
    @{ pattern = 'assets/img/inner-page/contact-bg\.jpg';       alt = ''; decorative = $true },
    @{ pattern = 'assets/img/inner-page/about-image\.jpg';      alt = 'RequiredFilings team' },
    @{ pattern = 'assets/img/inner-page/about-info\.png';       alt = ''; decorative = $true },
    @{ pattern = 'assets/img/inner-page/service-details-01\.jpg'; alt = 'Service overview' },
    @{ pattern = 'assets/img/inner-page/project-details-05\.jpg'; alt = 'Filing case study' },
    @{ pattern = 'assets/img/inner-page/team-1\.jpg';           alt = 'Team member portrait' },
    @{ pattern = 'assets/img/inner-page/team-2\.jpg';           alt = 'Team member portrait' },
    @{ pattern = 'assets/img/inner-page/team-3\.jpg';           alt = 'Team member portrait' },
    @{ pattern = 'assets/img/inner-page/team-04\.jpg';          alt = 'Team member portrait' }
)

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$totalChanged = 0

foreach ($h in $htmls) {
    $c = [System.IO.File]::ReadAllText($h.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c

    foreach ($m in $altMap) {
        $replacement = if ($m.decorative) {
            ' alt="" aria-hidden="true"'
        } else {
            ' alt="' + $m.alt + '"'
        }
        # Match src="<pattern>" followed by alt="img" or alt="imgt"
        $rx = '(src="' + $m.pattern + '")\s+alt="(?:img|imgt)"'
        $c = [regex]::Replace($c, $rx, '$1' + $replacement)
    }

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($h.FullName, $c, $utf8NoBom)
        $totalChanged++
        Write-Host "Updated: $($h.Name)"
    }
}

Write-Host "Total files updated: $totalChanged"
