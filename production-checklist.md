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
- [ ] Replace generic stock hero/about images with compliance-relevant visuals
- [ ] Remove or replace the brand carousel (currently `brand-1/2/3.png`)
- [x] Update favicon (`assets/img/favicon.svg`)
- [ ] Remove dark-mode / RTL / color-switcher widgets (or commit to shipping them)

### 3. Contact form backend
- [ ] Pick a backend (Formspree / Web3Forms / Netlify Forms / custom PHP/Node)
- [ ] Replace `action="[TBD-form-endpoint]"` across all 10 pages with real endpoint
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
- [ ] Add social links (LinkedIn at minimum)
- [x] Display GSTIN in footer
- [x] Display CIN / firm registration numbers in footer

### 5. Legal pages
- [x] Privacy Policy page
- [x] Terms of Service / Engagement Terms page
- [x] Refund & Cancellation Policy page
- [x] Disclaimer (CA/advisory limitations) page
- [ ] Cookie notice banner (if running analytics)

---

## P1 — Credibility and SEO

### 6. SEO foundation
- [x] Unique `<title>` per page
- [x] Unique `<meta description>` per page
- [ ] Open Graph tags on every page
- [ ] Twitter card meta on every page
- [ ] `robots.txt`
- [ ] `sitemap.xml`
- [ ] Canonical tags on every page
- [ ] Schema.org `LocalBusiness` on home and contact
- [ ] Schema.org `Service` on each service page
- [ ] Schema.org `FAQPage` where FAQs exist
- [ ] Schema.org `BreadcrumbList`
- [ ] H1/H2 hierarchy audit and fix
- [x] `alt` text on all images

### 7. Blog setup
- [ ] Decide CMS vs. static approach
- [ ] First article: "GST registration documents and process"
- [ ] Second article: "ROC annual filing deadlines and penalties"
- [ ] Third article: "Pvt Ltd vs LLP — which to choose"
- [ ] Fourth article: "MSME Udyam registration process"
- [ ] Fifth article: "ISO 9001 cost and timeline in India"
- [ ] Replace template blog cards with real posts

### 8. Analytics and tracking
- [ ] Google Analytics 4 installed
- [ ] Google Search Console verified
- [ ] Sitemap submitted to Search Console
- [ ] Microsoft Clarity or Hotjar installed
- [ ] Conversion event: form submit
- [ ] Conversion event: phone click
- [ ] Conversion event: WhatsApp click

---

## P2 — Polish and QA before launch

### 9. Performance
- [ ] Convert images to WebP
- [ ] Compress all images
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
- [ ] Custom 404 page
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
