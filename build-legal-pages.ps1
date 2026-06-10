$root = 'd:\Website Projects\Required Filings Website\required-filings'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$template = [System.IO.File]::ReadAllText((Join-Path $root 'about.html'), [System.Text.Encoding]::UTF8)

# Slice 1: head through breadcrumb close.
$breadcrumbCloseMarker = "<!-- About Inner Section Start -->"
$idx1 = $template.IndexOf($breadcrumbCloseMarker)
if ($idx1 -lt 0) { throw 'breadcrumb marker not found' }
$headAndBreadcrumb = $template.Substring(0, $idx1)

# Slice 2: from CTA newsletter through end (footer + scripts).
$ctaMarker = "<!-- Cta Newsletter Section Start -->"
$idx2 = $template.IndexOf($ctaMarker)
if ($idx2 -lt 0) { throw 'cta marker not found' }
$ctaAndFooter = $template.Substring($idx2)

# Today
$today = '2026-06-11'

# Per-page metadata + content
$pages = @(
    @{
        file = 'privacy.html'
        title = 'Privacy Policy &mdash; RequiredFilings.com'
        description = 'How RequiredFilings.com collects, uses and protects your data when you ask us to handle your company registration, GST, tax and other compliance filings.'
        h1 = 'Privacy Policy.'
        breadcrumb = 'Privacy Policy'
        subTitle = 'WHAT WE DO WITH YOUR DATA'
        sectionH2 = 'Your data, your call.<br> We treat it that way.'
        intro = 'This policy explains what we collect, why, and what you can ask us to do about it. Last updated <strong>' + $today + '</strong>.'
        body = @'
<h3>What we collect</h3>
<p>When you contact us or hire us to file something, we collect the information you give us. That includes your name, business name, email, phone, address, PAN, Aadhaar, GSTIN, CIN, DIN, bank details, identity documents, and anything else needed to prepare your filing.</p>
<p>We also collect basic web analytics &mdash; pages visited, browser, country &mdash; through cookies. We do not collect this until you accept the cookie notice.</p>

<h3>Why we collect it</h3>
<ul>
    <li>To prepare and file your statutory filings with MCA, GSTN, Income Tax, EPFO, ESIC, FSSAI and similar portals.</li>
    <li>To send you deadline reminders, status updates, invoices and tax notices.</li>
    <li>To respond to your enquiries and provide support.</li>
    <li>To meet our own legal and regulatory obligations.</li>
</ul>

<h3>Who we share it with</h3>
<p>We share your information only with the people and systems that must see it to do your filing: the relevant government portal, the chartered accountant or company secretary assigned to your case, and the payment processor for your invoice. We do not sell your data. We do not share it for marketing.</p>

<h3>How long we keep it</h3>
<p>We keep your filings and supporting documents for as long as the law requires us to &mdash; in many cases 8 years for tax and 7 years under the Companies Act. We delete contact-form enquiries within 24 months if you do not become a client.</p>

<h3>Your rights</h3>
<p>You can ask us to show you what we hold about you, correct it, or delete it where the law allows. Email <a href="mailto:[TBD-email]">[TBD-email]</a> and we will respond within 30 days.</p>

<h3>Security</h3>
<p>Documents are sent through encrypted links. Access is restricted to the professional handling your file. We never email Aadhaar or PAN scans to ourselves &mdash; we use a secure document upload portal.</p>

<h3>Cookies</h3>
<p>We use essential cookies to keep the site working and optional analytics cookies to understand which pages help our clients most. You can decline analytics cookies in the banner.</p>

<h3>Contact</h3>
<p>Questions or complaints about your data: <a href="mailto:[TBD-email]">[TBD-email]</a> or write to <strong>[TBD: registered office address], India</strong>.</p>
'@
    },
    @{
        file = 'terms.html'
        title = 'Terms of Engagement &mdash; RequiredFilings.com'
        description = 'The terms under which RequiredFilings.com prepares and files compliance work for Indian businesses, including scope, fees, responsibilities and limitations.'
        h1 = 'Terms of Engagement.'
        breadcrumb = 'Terms of Engagement'
        subTitle = 'THE RULES OF WORKING TOGETHER'
        sectionH2 = 'Plain rules for <br>real filing work.'
        intro = 'These terms apply when you hire RequiredFilings.com to prepare or file any compliance work for your business. Last updated <strong>' + $today + '</strong>.'
        body = @'
<h3>1. Who we are</h3>
<p>RequiredFilings.com is operated by <strong>[TBD: legal entity name]</strong>, registered in India under <strong>CIN/Firm reg: [TBD]</strong> with <strong>GSTIN: [TBD]</strong>. Our registered office is <strong>[TBD: registered office address]</strong>.</p>

<h3>2. What we do</h3>
<p>We prepare and file statutory returns and applications for company registration, GST, income tax, ROC compliance, licenses, IPR, ISO and accounting. We act as your professional service provider, not as your statutory auditor unless a separate engagement letter says so.</p>

<h3>3. Quotes and fees</h3>
<p>Every engagement starts with a written quote that lists the scope, deliverables, government fees and our professional fees. Quotes are valid for 30 days. Government fees can change at any time &mdash; we will tell you before we pay them on your behalf.</p>

<h3>4. Payment</h3>
<p>Professional fees are payable in full before we begin work, unless the quote says otherwise. Government fees are reimbursable at cost. Invoices not paid within 15 days attract 18% per annum simple interest.</p>

<h3>5. Your responsibilities</h3>
<ul>
    <li>Give us complete, accurate, true documents.</li>
    <li>Respond to our requests within the time we ask for &mdash; statutory deadlines are not negotiable.</li>
    <li>Tell us about any prior filings, ongoing disputes, or pending notices when you onboard.</li>
    <li>Approve every draft before we submit it.</li>
</ul>

<h3>6. Our responsibilities</h3>
<ul>
    <li>Assign a qualified chartered accountant or company secretary to your file.</li>
    <li>File correctly and on time, based on the documents you give us.</li>
    <li>Tell you in writing about any deadline, penalty or risk we spot.</li>
    <li>Keep your data confidential per our <a href="privacy.html">privacy policy</a>.</li>
</ul>

<h3>7. Turnaround time</h3>
<p>Each quote gives you the working-day turnaround. Government portals, courier and verification timelines are outside our control. We do not promise outcomes that depend on a third party.</p>

<h3>8. Limitation of liability</h3>
<p>Our total liability for any claim arising from an engagement is limited to the professional fees you paid us for that engagement. We are not liable for penalties or losses caused by incomplete information you gave us, delayed approvals or actions you took without telling us.</p>

<h3>9. Termination</h3>
<p>Either party can end an engagement in writing. You pay for work completed up to the date we receive your written notice. We will hand over all documents and work-in-progress within 7 working days.</p>

<h3>10. Jurisdiction</h3>
<p>These terms are governed by the laws of India. Any dispute is subject to the exclusive jurisdiction of the courts at <strong>[TBD: city of registered office]</strong>.</p>

<h3>Contact</h3>
<p>Questions about these terms: <a href="mailto:[TBD-email]">[TBD-email]</a>.</p>
'@
    },
    @{
        file = 'refund.html'
        title = 'Refund &amp; Cancellation Policy &mdash; RequiredFilings.com'
        description = 'When and how you can cancel a RequiredFilings.com engagement and what portion of your fees will be refunded.'
        h1 = 'Refund &amp; Cancellation.'
        breadcrumb = 'Refund &amp; Cancellation'
        subTitle = 'IF YOU NEED TO CANCEL'
        sectionH2 = 'A fair refund <br>for honest cancellations.'
        intro = 'This policy covers professional fee refunds. Government fees and third-party costs already paid on your behalf are not refundable. Last updated <strong>' + $today + '</strong>.'
        body = @'
<h3>When you can cancel</h3>
<p>You can cancel any engagement in writing at any time before we file. Email <a href="mailto:[TBD-email]">[TBD-email]</a> with the subject line <em>Cancellation: [your invoice or quote number]</em>.</p>

<h3>How much we refund</h3>
<ul>
    <li><strong>Within 24 hours of payment and before we have started work:</strong> 100% refund of professional fees.</li>
    <li><strong>After we have started but before we have drafted your filing:</strong> 50% refund of professional fees.</li>
    <li><strong>After we have shared a draft for your approval:</strong> no refund of professional fees.</li>
    <li><strong>After we have filed:</strong> no refund &mdash; the work is complete.</li>
</ul>
<p>Government fees we have already paid on your behalf (MCA, GST, ROC, FSSAI, Income Tax, etc.) are not refundable by us &mdash; that money has left our hands. We will share the payment proof.</p>

<h3>When we cancel</h3>
<p>We may end an engagement if you do not respond within 30 days, if documents you supply turn out to be false, or if the work falls outside our professional scope. In each case we refund unutilised fees on the same basis above.</p>

<h3>How refunds are paid</h3>
<p>Refunds go to the same bank account or card that paid us. Bank refunds take 5 to 10 working days. Card refunds take 7 to 14 working days, depending on your bank.</p>

<h3>Disputes</h3>
<p>If you disagree with a refund decision, email <a href="mailto:[TBD-email]">[TBD-email]</a>. A senior member of our team will respond within 7 working days. If still unresolved, the dispute is governed by our <a href="terms.html">terms of engagement</a>.</p>
'@
    },
    @{
        file = 'disclaimer.html'
        title = 'Disclaimer &mdash; RequiredFilings.com'
        description = 'What RequiredFilings.com is and is not, the limits of online compliance content, and when you must talk to a qualified chartered accountant or company secretary.'
        h1 = 'Disclaimer.'
        breadcrumb = 'Disclaimer'
        subTitle = 'IMPORTANT NOTICES'
        sectionH2 = 'What this site is. <br>And what it is not.'
        intro = 'This page sets out what RequiredFilings.com is, the limits of our published content, and the regulatory framework we operate in. Last updated <strong>' + $today + '</strong>.'
        body = @'
<h3>Information vs advice</h3>
<p>The articles, guides and pages on this website are general information, written to help Indian business owners understand their statutory filing obligations. They are not legal, tax, accounting or investment advice for your specific situation. Talk to a qualified chartered accountant, company secretary or lawyer before acting on anything you read here.</p>

<h3>Who can do statutory work</h3>
<p>Statutory audit, certification of returns under the Income Tax Act, and several MCA filings are reserved by law for chartered accountants, company secretaries, cost accountants or advocates. RequiredFilings.com partners with qualified professionals to perform such work &mdash; we do not pretend to do it ourselves where the law does not permit.</p>

<h3>Accuracy</h3>
<p>Indian tax, GST and corporate law change often. We update content as fast as we can, but laws may change between our update and the day you read this page. Always confirm timelines, fees and forms with the current government portal before you act.</p>

<h3>No guarantees of outcome</h3>
<p>We do not guarantee that any application will be approved by a government authority. Approval depends on the authority and the completeness of documents you supply.</p>

<h3>Third-party links</h3>
<p>This website links to MCA, GSTN, Income Tax, FSSAI, EPFO, ESIC and other portals for your convenience. We do not control those sites. We are not responsible for their content or downtime.</p>

<h3>Testimonials and case studies</h3>
<p>Testimonials, case studies and recent-filing examples are from real clients with their permission. Names and identifying details are changed where the client asked. Past results do not guarantee future results.</p>

<h3>Trademarks</h3>
<p>RequiredFilings.com is a trademark of <strong>[TBD: legal entity name]</strong>. All other names, logos and marks belong to their respective owners.</p>

<h3>Contact</h3>
<p>Spot a mistake or have a clarification: <a href="mailto:[TBD-email]">[TBD-email]</a>.</p>
'@
    }
)

foreach ($p in $pages) {
    # Build the legal-section content
    $section = @"
                <!-- Legal Content Section Start -->
                <section class="about-inner-section fix section-padding">
                    <div class="container">
                        <div class="section-title-area align-items-end">
                            <div class="section-title">
                                <h6 class="sub-title wow fadeInUp">
                                    <img src="assets/img/home-1/star.svg" alt="" aria-hidden="true">$($p.subTitle)
                                </h6>
                                <h2 class="text-anim">
                                    $($p.sectionH2)
                                </h2>
                            </div>
                        </div>
                        <div class="row g-4">
                            <div class="col-lg-12 wow fadeInUp" data-wow-delay=".3s">
                                <div class="rf-legal-content">
                                    <p class="lead">$($p.intro)</p>
                                    $($p.body)
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

"@

    # Build new head/breadcrumb that swaps title, description and breadcrumb text
    $newHead = $headAndBreadcrumb

    # Swap title
    $newHead = [regex]::Replace($newHead, '<title>[^<]*</title>', "<title>$($p.title)</title>", 1)

    # Swap meta description
    $newHead = [regex]::Replace($newHead, '<meta name="description" content="[^"]*">', "<meta name=`"description`" content=`"$($p.description)`">", 1)

    # Swap breadcrumb H1 + breadcrumb last item
    $newHead = [regex]::Replace($newHead, '<h1 class="text-white wow fadeInUp" data-wow-delay="\.3s">[^<]+</h1>', "<h1 class=`"text-white wow fadeInUp`" data-wow-delay=`".3s`">$($p.h1)</h1>", 1)
    $newHead = [regex]::Replace($newHead, '(?s)(<li>\s*/\s*</li>\s*<li>)\s*[^<]+(</li>)', ('$1' + "`r`n                                    " + $p.breadcrumb + '$2'), 1)

    # Tiny inline style for the legal content typography (legal pages only)
    $legalStyle = @'
        <!-- RF legal-page typography -->
        <style>.rf-legal-content{max-width:820px;margin:0 auto}.rf-legal-content .lead{font-size:1.05rem;color:#555;margin-bottom:2rem}.rf-legal-content h3{margin-top:2.25rem;margin-bottom:.85rem;font-size:1.35rem;font-weight:600}.rf-legal-content p{margin-bottom:1rem;line-height:1.75}.rf-legal-content ul{margin:1rem 0 1.25rem 1.25rem;line-height:1.75}.rf-legal-content li{margin-bottom:.4rem}.rf-legal-content a{color:#3B82F6;text-decoration:underline}.rf-legal-content strong{color:#222}</style>
'@
    $newHead = $newHead -replace '(<!-- RF form helpers -->)', ($legalStyle + "`r`n        " + '$1')

    $fullPage = $newHead + $section + $ctaAndFooter

    $outPath = Join-Path $root $p.file
    [System.IO.File]::WriteAllText($outPath, $fullPage, $utf8NoBom)
    Write-Host "Wrote: $($p.file)"
}
