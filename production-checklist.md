# RequiredFilings.com — Production Launch Checklist

**Source of truth.** Tick items as `- [x]` when complete, then run `.\sync-progress.ps1` to mirror progress into [CLAUDE.md](CLAUDE.md).

**References**
- Content principles: [buyer-file/content-principles.md](buyer-file/content-principles.md)
- Sitemap: [buyer-file/sitemap-required-filings.md](buyer-file/sitemap-required-filings.md)
- Pages live in: [required-filings/](required-filings/)

---

## P0 — Cannot launch without these

### 1. Content (apply content principles to every page)
- [x] Home — rewrite hero, value props, services grid, social proof, CTA (kill all Brevon/Lorem)
- [x] start-a-business.html — 6-section decision journey (What it is → Who needs it → Consequence → What we do → Documents → CTA)
- [x] statutory-registrations.html — 6-section decision journey
- [x] licenses.html — 6-section decision journey
- [x] roc-compliance.html — 6-section decision journey
- [x] tax-services.html — 6-section decision journey
- [x] gst-services.html — 6-section decision journey
- [x] ipr.html — 6-section decision journey
- [x] iso-certification.html — 6-section decision journey
- [x] msme-zed.html — 6-section decision journey
- [x] accounting.html — 6-section decision journey
- [x] services.html — scannable overview linking to all 10 service pages
- [x] about.html — story, team, credentials, years operating, filings completed
- [x] contact.html — real address, phones, emails, hours, real map
- [x] Replace every CTA ("Learn More", "Get Started", "Send now") with named next actions
- [x] Rewrite footer tagline ("The purpose of a FAQ is generally…")
- [x] Remove or replace fake newsletter block on every page

### 2. Branding & assets
- [x] Replace `assets/img/logo/black-logo.svg` with RequiredFilings logo
- [x] Replace `assets/img/logo/white-logo.svg` with RequiredFilings logo
- [x] Change preloader letters from `B-R-E-V-O-N` to RequiredFilings brand
- [x] Update `<title>` on every page (currently identical)
- [x] Update meta description on every page (currently identical)
- [x] Replace generic stock hero/about images with compliance-relevant visuals
- [x] Remove or replace the brand carousel (currently `brand-1/2/3.png`)
- [x] Update favicon (`assets/img/favicon.svg`)
- [x] Remove dark-mode / RTL / color-switcher widgets (or commit to shipping them)

### 3. Contact form backend
- [x] Pick a backend (Formspree / Web3Forms / Netlify Forms / custom PHP/Node)
- [x] Replace `action="[TBD-form-endpoint]"` across all 10 pages with real endpoint
- [x] Add `name`, `email`, `phone` attributes to all inputs
- [x] Wrap inputs in proper `<label>` elements
- [x] Add client-side validation + required fields
- [x] Add honeypot or reCAPTCHA
- [x] Add visible success and error states
- [x] Replace service dropdown options (currently "Digital Marketing", "Software & IT Service", "Finance & Investment")
- [ ] Configure auto-responder email to lead
- [ ] Configure internal notification email
- [ ] Decide CRM destination (HubSpot / Zoho / Notion / Google Sheets)

### 4. Real business data
- [x] Replace `+8 (666) 123-3562` everywhere with real phone
- [x] Add WhatsApp click-to-chat link
- [x] Add real email address(es)
- [x] Add office address(es)
- [x] Replace Melbourne "Envato" Google Map embed with real location
- [x] Add social links (LinkedIn at minimum) — resolved by removing all social icons site-wide 2026-07-17 (no accounts exist yet). Reintroduce when real URLs are supplied.
- [x] Display GSTIN in footer
- [x] Display CIN / firm registration numbers in footer

### 5. Legal pages
- [x] Privacy Policy page
- [x] Terms of Service / Engagement Terms page
- [x] Refund & Cancellation Policy page
- [x] Disclaimer (CA/advisory limitations) page
- [x] Cookie notice banner (if running analytics)

---

## P1 — Credibility and SEO

### 6. SEO foundation
- [x] Unique `<title>` per page
- [x] Unique `<meta description>` per page
- [x] Open Graph tags on every page
- [x] Twitter card meta on every page
- [x] `robots.txt`
- [x] `sitemap.xml`
- [x] Canonical tags on every page
- [x] Schema.org `LocalBusiness` on home and contact
- [x] Schema.org `Service` on each service page
- [ ] Schema.org `FAQPage` where FAQs exist — deferred: home/about/accounting/msme-zed have "How it works" process accordions, not true Q&A. Add proper FAQ content first, then schema.
- [x] Schema.org `BreadcrumbList`
- [ ] H1/H2 hierarchy audit and fix
- [x] `alt` text on all images

### 7. Blog setup
- [ ] Decide CMS vs. static approach
- [ ] First article: "GST registration documents and process"
- [ ] Second article: "ROC annual filing deadlines and penalties"
- [ ] Third article: "Pvt Ltd vs LLP — which to choose"
- [ ] Fourth article: "MSME Udyam registration process"
- [ ] Fifth article: "ISO 9001 cost and timeline in India"
- [x] Replace template blog cards with real posts — resolved 2026-07-17 by removing home news-section and replacing blog.html card grid with an "Articles publishing soon" empty state. Reintroduce cards when real articles ship.

### 8. Analytics and tracking
- [ ] Google Analytics 4 installed — loader shipped in `assets/js/analytics.js` (consent-gated). Replace `[TBD-ga4-id]` with real `G-XXXXXXXXXX` to activate.
- [ ] Google Search Console verified — client-side (needs DNS TXT or HTML verification file).
- [ ] Sitemap submitted to Search Console — after verification.
- [ ] Microsoft Clarity or Hotjar installed — loader shipped in `assets/js/analytics.js` (consent-gated). Replace `[TBD-clarity-id]` with real Clarity project ID to activate.
- [x] Conversion event: form submit — wired in `analytics.js` (fires once GA4 ID is set).
- [x] Conversion event: phone click — wired in `analytics.js`.
- [x] Conversion event: WhatsApp click — wired in `analytics.js`.

---

## P2 — Polish and QA before launch

### 9. Performance
- [ ] Convert images to WebP — deferred (JPG re-encoding gave 96% size reduction; WebP would give another ~30%. Acceptable trade for launch.)
- [x] Compress all images — 5 India-context photos resized + re-encoded (12 MB → 430 KB total).
- [ ] Set width/height on all `<img>` tags
- [ ] Lazy-load below-the-fold images
- [ ] Minify CSS
- [ ] Minify JS
- [ ] Defer non-critical JS
- [ ] Remove unused CSS bundles (`rtl.css`, `dark-mode.css` if not needed)
- [ ] Lighthouse: Performance ≥ 90
- [ ] Lighthouse: SEO ≥ 90
- [ ] Lighthouse: Accessibility ≥ 90

### 10. Accessibility
- [ ] `<label>` for every form input
- [ ] Color contrast WCAG AA pass
- [ ] Keyboard navigation works (mobile menu, search, dropdowns)
- [ ] ARIA labels on icon-only buttons

### 11. QA
- [x] Custom 404 page
- [ ] Broken-link sweep across all pages
- [ ] Cross-browser test: Chrome
- [ ] Cross-browser test: Safari
- [ ] Cross-browser test: Firefox
- [ ] Cross-browser test: Edge
- [ ] Mobile breakpoint: 360px
- [ ] Mobile breakpoint: 414px
- [ ] Tablet breakpoint: 768px
- [ ] Desktop breakpoint: 1024px+
- [ ] Form submission tested end-to-end
- [ ] `tel:` links work on mobile
- [ ] `mailto:` links work on mobile

### 12. Hosting and deployment
- [ ] Domain DNS pointed to requiredfilings.com
- [ ] SSL certificate active
- [ ] Hosting target chosen (Netlify / Vercel / cPanel / Cloudflare Pages)
- [ ] 301 redirects configured for any old URLs
- [ ] Automated backups configured

---

## P3 — Post-launch

- [ ] Sitemap submitted to Bing Webmaster Tools
- [ ] Monthly blog content cadence set
- [ ] GA4 + Clarity reviewed weekly for first month
- [ ] Real client testimonials collected and published
- [ ] Case studies published (with client permission)
