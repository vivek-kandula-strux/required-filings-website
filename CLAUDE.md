# RequiredFilings.com — Project Context

## What this is
Production website for RequiredFilings.com, a compliance and filing services company in India (company registration, statutory filings, GST, tax, ROC, IPR, ISO, MSME, accounting).

The site is built on top of the Brevon HTML template. 15 pages live as flat HTML in [required-filings/](required-filings/). The template is mostly in place; the real work is replacing template content, branding, and stubs with production content per the content principles.

## Source files
- **Checklist (source of truth):** [production-checklist.md](production-checklist.md)
- **Content principles:** [buyer-file/content-principles.md](buyer-file/content-principles.md) — every word on the site must follow these
- **Sitemap:** [buyer-file/sitemap-required-filings.md](buyer-file/sitemap-required-filings.md)
- **Pages:** [required-filings/](required-filings/) (flat HTML, edit directly)
- **Assets:** [required-filings/assets/](required-filings/assets/) (img, css, js, scss, webfonts)

## Working rules
- All copy must follow [content-principles.md](buyer-file/content-principles.md): plain English, 12-word sentences max, "you/your", consequences not just services, statements not labels, named CTAs.
- No Brevon template content (Lorem ipsum, "Brevon", "Innovative Solution For Modern Global Businesses", "+8 (666) 123-3562", Envato Melbourne map, fake testimonials) is allowed in production.
- Pages are flat HTML — no build step. Edit `.html` files directly.
- Default Bash tools work; this is Windows, so prefer PowerShell for `.ps1` scripts.

## WIREFRAME LOCK (do not violate)
The wireframe is **locked** as of 2026-06-11. The cross-page section structure mirrors [buyer-file/index.html](buyer-file/index.html) and was reconciled with `required-filings/index.html` in the same session (preloader restored, BREVON watermark stripped).
- **Do not add, remove, reorder, or restructure top-level sections** (`<section>` blocks, header, footer, hero, brand carousel, service grid, about, feature slider, project marquee, testimonials, FAQ accordion, pricing, marquee-2, news, CTA newsletter, preloader, offcanvas, color-switcher, search popup).
- **Do not change the column grid** (`col-lg-*`, `col-xl-*`), card counts per row, image aspect-ratio containers, or swiper slide counts.
- **Do not delete or rename existing CSS classes** that the wireframe depends on (`hero-section`, `feature-box-items`, `pricing-box-items`, `news-box-items`, `accordion-box`, `marquee-group`, `swiper-slide`, etc.).
- **Content swaps are fine** — text, image `src`, alt, link href, dropdown options, form `name`/`label`/validation, `<title>`, meta tags, schema, business data, footer addresses.
- **Visually-hidden helpers are fine** (`sr-only`-style labels, honeypot inputs, ARIA, hidden inputs).
- **New pages** (e.g. legal pages) must reuse the same template wireframe (header + breadcrumb + content section + footer + script bundle) — do not invent a new layout.
- If a change *must* break the wireframe, stop and ask the user first.

## UTF-8 / encoding rule
When editing HTML programmatically, read with `[System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)` and write with `[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding $false))`. The `Get-Content -Raw` / `Set-Content -Encoding utf8` pair will mojibake em-dashes (`—` → `â€"`), curly quotes, and `₹`. Helper scripts `fix-mojibake.ps1` and `fix-alt-text.ps1` at repo root use the safe pattern.

## P0 blockers needing real business data (TBD-* placeholders in the codebase)
These are the only P0 items still open. They cannot be closed by code alone — they need the actual business detail from the owner. Search the codebase for the bracketed token to find every site that needs the value plugged in:
- `[TBD-phone]` — real Indian phone number for `tel:` links and visible text. Used in header, offcanvas, footer, contact page.
- `[TBD-email]` — real contact email for `mailto:` links and visible text. Used in header, offcanvas, footer, contact form error message, legal pages.
- `[TBD: office address]`, `[TBD: registered office address]` — real Indian street address. Used in offcanvas, contact page, footer, legal pages.
- `[TBD: +91 phone]`, `[TBD: hello@requiredfilings.com]` — visible label variants of the above.
- `[TBD: city of registered office]` — used in terms.html jurisdiction clause.
- `[TBD: legal entity name]` — operating company name for terms.html and disclaimer.html.
- `[TBD: founder name]`, `[TBD: year founded]` — about.html story section.
- `[TBD: client name]`, `[TBD: business type and city]` — homepage testimonial section. Replace when real testimonials are collected.
- `[TBD]` — appears as `<span>[TBD]</span>` for stat counters (filings completed, on-time rate, etc.). Real numbers needed.
- `GSTIN: [TBD]` — footer GSTIN line. Need real GSTIN.
- `CIN/Firm reg: [TBD]` — terms.html company registration line.
- `[TBD-form-endpoint]` — the `<form action=>` URL on every contact form. After picking a backend (Formspree, Web3Forms, Netlify Forms, etc.) replace site-wide with a single find-and-replace.
- `[TBD-newsletter-endpoint]` — newsletter signup form action URL. Same fix pattern as above.
- `[TBD-map-embed]` — Google Maps embed URL on contact.html.
- `[TBD: date]` — blog post and news card dates.
- `[TBD: real client testimonial pending. ...]` — three testimonial slides.
- Brand carousel (`brand-1.png` … `brand-6.png`) and stock hero/about/news/project photos remain template-default. Real client logos and real photography are still needed (P0 §2 items still open).
- Cookie banner is intentionally deferred until GA4 or Clarity is installed (P0 §5 last item, dependent on P1 §8).
- Color-switcher / dark-mode / RTL widgets are intentionally kept (wireframe lock); the corresponding P0 §2 item is a decision deferred to the owner.

When the owner provides any of these, do a global find-and-replace on the literal bracketed token and tick the matching production-checklist item.

## Auto-sync workflow (READ THIS BEFORE MARKING ITEMS DONE)
When you complete a checklist item:
1. Edit [production-checklist.md](production-checklist.md) — change `- [ ]` to `- [x]`.
2. Run the sync script: `powershell -ExecutionPolicy Bypass -File .\sync-progress.ps1`
3. The script regenerates the **Progress Snapshot** block below from the checklist.

The Progress Snapshot is auto-generated. Do not edit it by hand — your edits will be overwritten on next sync.

---

<!-- PROGRESS:START -->
## Progress Snapshot
**37 / 115 items complete (32.2%)** - last synced 2026-06-11 00:34

### By section
- **P0 — Cannot launch without these** - 34 / 50 (68%)
- **P1 — Credibility and SEO** - 3 / 27 (11%)
- **P2 — Polish and QA before launch** - 0 / 33 (0%)
- **P3 — Post-launch** - 0 / 5 (0%)

### Full checklist (mirror)

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
- [ ] Replace `+8 (666) 123-3562` everywhere with real phone
- [ ] Add WhatsApp click-to-chat link
- [ ] Add real email address(es)
- [ ] Add office address(es)
- [x] Replace Melbourne "Envato" Google Map embed with real location
- [ ] Add social links (LinkedIn at minimum)
- [ ] Display GSTIN in footer
- [ ] Display CIN / firm registration numbers in footer

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
<!-- PROGRESS:END -->
