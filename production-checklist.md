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
- [x] Schema.org `FAQPage` where FAQs exist — added to about.html, accounting.html, msme-zed.html (5 Q&As each). index.html accordion is process steps, not FAQ — skipped.
- [x] Schema.org `BreadcrumbList`
- [x] H1/H2 hierarchy audit and fix — html-validate passes 0 errors, 0 warnings; all heading jumps fixed
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
- [x] Convert images to WebP — done 2026-07-18 (Python Pillow, quality 82). breadcrumb-bg 54% smaller, cta-newsletter 60% smaller, hero-bg 54% smaller, about-image 34% smaller. All 20 pages updated to .webp URLs. JPEG originals kept for fallback.
- [x] Compress all images — 5 India-context photos resized + re-encoded (12 MB → 430 KB total).
- [x] Set width/height on all `<img>` tags — 157 images across 20 pages (Phase 10.2)
- [x] Lazy-load below-the-fold images — `loading="lazy" decoding="async"` on all below-fold images; LCP images kept eager (Phase 10.2)
- [x] Minify CSS — `npm run build` produces `dist/assets/css/main.css` (352 KB → 298 KB, 19.8% saving; already-min files copied as-is)
- [x] Minify JS — `npm run build` produces `dist/assets/js/` (94 KB → 45 KB across 11 files, 52.2% saving; `.min.js` files copied as-is)
- [x] Minify HTML — `npm run build` produces `dist/*.html` (1.26 MB → 628 KB across 20 pages, 50.1% saving)
- [x] Defer non-critical JS — all scripts placed at end of `<body>`; equivalent to defer for render-blocking purposes
- [x] Remove unused CSS bundles (`rtl.css`, `dark-mode.css` if not needed) — both removed from all pages (Phase 12.4)
- [ ] Lighthouse: Performance ≥ 90
- [ ] Lighthouse: SEO ≥ 90
- [ ] Lighthouse: Accessibility ≥ 90

### 10. Accessibility
- [x] `<label>` for every form input — visually-hidden labels with `for` attribute on all inputs/selects/textareas (Phase 13.3)
- [x] Color contrast WCAG AA pass — --primary 6.4:1, --accent 6.1:1, body text 19:1 on white (Phase 13.4)
- [ ] Keyboard navigation works (mobile menu, search, dropdowns) — requires browser test (Phase 13.1)
- [x] ARIA labels on icon-only buttons — back-to-top, carousel prev/next, hamburger, offcanvas close, phone icon, WhatsApp float, mobile bar (Phase 1.7, 1.10)

### 11. QA
- [x] Custom 404 page
- [x] Broken-link sweep across all pages — 0 broken internal page links; 0 broken asset references (CSS/JS/images) across all 20 pages
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
- [x] Hosting target chosen — cPanel/Apache (build-deploy-zip.ps1 produces the upload zip)
- [x] `.htaccess` shipped with production zip (gzip, brotli, 1yr cache, HTTPS+HSTS, security headers, custom 404) — `required-filings/.htaccess`
- [ ] 301 redirects configured for any old URLs — none needed pre-launch
- [ ] Automated backups configured — cPanel-side setting

---

## P3 — Post-launch

- [ ] Sitemap submitted to Bing Webmaster Tools
- [ ] Monthly blog content cadence set
- [ ] GA4 + Clarity reviewed weekly for first month
- [ ] Real client testimonials collected and published
- [ ] Case studies published (with client permission)
