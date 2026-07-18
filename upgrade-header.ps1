# upgrade-header.ps1
# Replaces the <!-- Header Section Start --> ... </header> block on every page
# with a new premium glassy mega-menu header.
# Preserves aria-current="page" on the correct link for each page.

$ErrorActionPreference = 'Stop'

$pagesDir = Join-Path $PSScriptRoot 'required-filings'

# Map filename -> aria key (which link gets aria-current="page")
$ariaMap = @{
    'index.html'                    = 'home'
    'about.html'                    = 'about'
    'contact.html'                  = 'contact'
    'services.html'                 = 'allservices'
    'start-a-business.html'         = 'sab'
    'statutory-registrations.html'  = 'stat'
    'licenses.html'                 = 'lic'
    'roc-compliance.html'           = 'roc'
    'tax-services.html'             = 'tax'
    'gst-services.html'             = 'gst'
    'ipr.html'                      = 'ipr'
    'iso-certification.html'        = 'iso'
    'msme-zed.html'                 = 'msme'
    'accounting.html'               = 'acc'
    'blog.html'                     = 'none'
    'privacy.html'                  = 'none'
    'terms.html'                    = 'none'
    'refund.html'                   = 'none'
    'disclaimer.html'               = 'none'
    '404.html'                      = 'none'
}

function New-HeaderMarkup {
    param([string]$AriaKey)

    # helper to produce ' aria-current="page"' when the key matches
    function C([string]$expected) { if ($AriaKey -eq $expected) { ' aria-current="page"' } else { '' } }

    # parent trigger gets aria-current too if any child is current — makes visual state cleaner
    $parentCompanyReg = if ($AriaKey -in 'sab','stat','lic','roc') { ' aria-current="page"' } else { '' }
    $parentAccounting = if ($AriaKey -in 'tax','gst') { ' aria-current="page"' } else { '' }
    $parentServices = if ($AriaKey -in 'allservices','ipr','iso','msme','acc') { ' aria-current="page"' } else { '' }

    $aHome = C 'home'
    $aAbout = C 'about'
    $aContact = C 'contact'
    $aSab = C 'sab'
    $aStat = C 'stat'
    $aLic = C 'lic'
    $aRoc = C 'roc'
    $aTax = C 'tax'
    $aGst = C 'gst'
    $aAllSvc = C 'allservices'
    $aIpr = C 'ipr'
    $aIso = C 'iso'
    $aMsme = C 'msme'
    $aAcc = C 'acc'

    # Note: we keep <ul class="submenu"> so meanmenu.js still clones dropdowns to the mobile drawer.
    # Extra rf-mega classes let CSS turn it into a rich desktop mega panel.
    # Icons/descriptions inside <a> are hidden by CSS in the mobile mean-nav clone.

    @"
            <!-- Header Section Start -->
            <header id="header-sticky" class="header-1 rf-nav">
                <div class="container">
                    <div class="mega-menu-wrapper">
                        <div class="header-main">
                            <a href="index.html" class="logo">
                                <img src="assets/img/logo/white-logo.svg" alt="RequiredFilings.com" width="180" height="180">
                            </a>
                            <div class="mean__menu-wrapper">
                                <div class="main-menu">
                                    <nav id="mobile-menu" aria-label="Main navigation">
                                        <ul>
                                            <li>
                                                <a href="index.html"$aHome>Home</a>
                                            </li>
                                            <li class="has-dropdown has-mega">
                                                <a href="javascript:void(0)"$parentCompanyReg aria-haspopup="true" aria-expanded="false">
                                                    Company Registration
                                                    <i class="fa-solid fa-chevron-down" aria-hidden="true"></i>
                                                </a>
                                                <ul class="submenu rf-mega rf-mega--4">
                                                    <li>
                                                        <a href="start-a-business.html"$aSab>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M3 21h18M5 21V7l7-4 7 4v14"/><path d="M9 9h.01M9 13h.01M9 17h.01M15 9h.01M15 13h.01M15 17h.01"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">Start a Business</span>
                                                                <span class="rf-mega__desc">Incorporate a Pvt Ltd, LLP or OPC.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="statutory-registrations.html"$aStat>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">Statutory Registrations</span>
                                                                <span class="rf-mega__desc">PAN, TAN, PF, ESIC and Shops &amp; Est.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="licenses.html"$aLic>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M8 2v4M16 2v4M3 10h18M7 15h6M7 18h4"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">Licenses</span>
                                                                <span class="rf-mega__desc">Trade, FSSAI, IEC and regulatory approvals.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="roc-compliance.html"$aRoc>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6M16 13H8M16 17H8M10 9H8"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">ROC &amp; Corporate Compliance</span>
                                                                <span class="rf-mega__desc">Annual filings, DIR-3 KYC and board minutes.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li class="has-dropdown has-mega">
                                                <a href="javascript:void(0)"$parentAccounting aria-haspopup="true" aria-expanded="false">
                                                    Accounting
                                                    <i class="fa-solid fa-chevron-down" aria-hidden="true"></i>
                                                </a>
                                                <ul class="submenu rf-mega rf-mega--2">
                                                    <li>
                                                        <a href="tax-services.html"$aTax>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">Tax Services</span>
                                                                <span class="rf-mega__desc">Income tax, TDS and statutory audit.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="gst-services.html"$aGst>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/><path d="M9 14l2 2 4-4"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">GST Services</span>
                                                                <span class="rf-mega__desc">Registration, monthly returns and notices.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li class="has-dropdown has-mega">
                                                <a href="javascript:void(0)"$parentServices aria-haspopup="true" aria-expanded="false">
                                                    Services
                                                    <i class="fa-solid fa-chevron-down" aria-hidden="true"></i>
                                                </a>
                                                <ul class="submenu rf-mega rf-mega--4">
                                                    <li>
                                                        <a href="services.html"$aAllSvc>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">All Services</span>
                                                                <span class="rf-mega__desc">Every filing we handle, on one page.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="ipr.html"$aIpr>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">Intellectual Property</span>
                                                                <span class="rf-mega__desc">Trademarks, copyrights and patents.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="iso-certification.html"$aIso>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="9" r="6"/><path d="M8.21 13.89L7 22l5-3 5 3-1.21-8.11"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">ISO Certification</span>
                                                                <span class="rf-mega__desc">9001, 14001, 27001 and 45001 audits.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="msme-zed.html"$aMsme>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">MSME &amp; ZED</span>
                                                                <span class="rf-mega__desc">Udyam registration and ZED certification.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a href="accounting.html"$aAcc>
                                                            <span class="rf-mega__icon" aria-hidden="true">
                                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6M8 13h8M8 17h5"/></svg>
                                                            </span>
                                                            <span class="rf-mega__body">
                                                                <span class="rf-mega__title">Accounting &amp; Bookkeeping</span>
                                                                <span class="rf-mega__desc">Monthly books, MIS and payroll.</span>
                                                            </span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li>
                                                <a href="about.html"$aAbout>About Us</a>
                                            </li>
                                            <li>
                                                <a href="contact.html"$aContact>Contact</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                            <div class="header-right d-flex justify-content-end align-items-center">
                                <a href="tel:+919502715353" class="rf-nav__call d-none d-lg-inline-flex" aria-label="Call +91 95027 15353">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                </a>
                                <a href="contact.html" class="theme-btn d-none d-xxl-block">
                                    <div class="btn_inner">
                                        <div class="btn_icon">
                                        <span>
                                        <i class="fa-solid fa-arrow-up-right" aria-hidden="true"></i>
                                        <i class="fa-solid fa-arrow-up-right" aria-hidden="true"></i>
                                        </span>
                                        </div>
                                        <div class="btn_text">
                                        <span>Talk to a filing expert</span>
                                        </div>
                                    </div>
                                </a>
                                <div class="header__hamburger d-xl-none my-auto">
                                    <button class="sidebar__toggle" type="button" aria-label="Open navigation menu"><i class="fa-regular fa-bars" aria-hidden="true"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
"@
}

# Regex to match <!-- Header Section Start --> ... </header> including surrounding whitespace on the line
$headerRegex = '(?s)([ \t]*)<!--\s*Header Section Start\s*-->\s*\r?\n[\s\S]*?</header>\r?\n?'

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$updated = 0
$skipped = 0

foreach ($file in $ariaMap.Keys) {
    $path = Join-Path $pagesDir $file
    if (-not (Test-Path $path)) {
        Write-Warning "Missing: $file"
        $skipped++
        continue
    }
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    if ($content -notmatch '<!--\s*Header Section Start\s*-->') {
        Write-Warning "No header marker in $file"
        $skipped++
        continue
    }
    $newHeader = New-HeaderMarkup -AriaKey $ariaMap[$file]
    # Preserve original leading whitespace before <!-- Header Section Start --> so the block sits at the right indent
    $updatedContent = [regex]::Replace($content, $headerRegex, {
        param($m)
        $indent = $m.Groups[1].Value
        # Prepend indent to each line of $newHeader so the block sits at parent indent; but $newHeader already starts with 12-space indent tuned for the wrapper. Preserve original file indent instead.
        # We'll just emit $newHeader as-is because the template already has appropriate indentation (12 spaces before <!-- ... -->).
        return $newHeader + "`r`n"
    })
    if ($updatedContent -eq $content) {
        Write-Warning "No change in $file (regex didn't match?)"
        $skipped++
        continue
    }
    [System.IO.File]::WriteAllText($path, $updatedContent, $utf8NoBom)
    Write-Host "Updated: $file" -ForegroundColor Green
    $updated++
}

Write-Host ""
Write-Host "Done. Updated $updated file(s). Skipped $skipped." -ForegroundColor Cyan
