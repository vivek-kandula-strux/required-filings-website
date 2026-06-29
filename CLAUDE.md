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

## Intake-checklist data applied 2026-06-11

The client-intake-checklist.docx was returned by **B.Yamini** on 2026-06-27 and applied to the site by `apply-intake-data.ps1`, `apply-pricing-onrequest.ps1`, `apply-intake-data-2.ps1`, and `add-whatsapp.ps1`. The values now baked into every page:

| Field | Value |
|---|---|
| Phone (also WhatsApp) | `+91 95027 15353` (E.164 `+919502715353`) |
| Primary email | `srivaarahi.gst@srivaarahi.com` |
| Secondary email (not displayed) | `neelambar@srivaarahi.com` |
| Office / registered address | 1-3-183/40/A/B, Flat-101, Plot No-34, Udaya Aditya Apts, Gandhinagar, Hyderabad — 500080 |
| Jurisdiction city | Hyderabad |
| Working hours | Mon–Sat, 10:00–18:00 IST |
| Legal entity | Sri Vaarahi Computer Services Pvt. Ltd. |
| CIN | U72900TG2017PTC118162 |
| GSTIN | 36AAYCS9154Q1ZZ |
| Founder | Neelambar Vadrevu (Managing Director) |
| Year founded | 2017 |
| Filings completed | 10,800 |
| On-time rate | 98% |
| Active clients | 127 (not shown publicly per intake — kept for internal reference) |
| Authorised capital threshold | ₹1,00,000 |
| Pricing | Every service tier set to "On request" (client opted not to publish rupee amounts) |
| Case studies | Filled with intake numbers — 26+ Pvt Ltd incorporations / 10–15 GST notice resolutions / 87+ Udyam + 4+ ISO certifications |
| Map embed | Address-based Google Maps `q=` URL on contact.html (works without an API key) |
| Team slot 1 | Neelambar Vadrevu, Founder & Managing Director |
| Team slot 2 | Radhika Vadrevu (role pending — intake left blank) |

## Still pending after intake (TBD tokens that remain)

Only **three** TBD tokens still appear in the codebase, all blocked on infra decisions:

- `[TBD-form-endpoint]` — `<form action="">` on every contact form. **Intake choice:** the client ticked both "simple email to a fixed address" AND "Google Sheets" (so the same lead must do both). Action: sign up for **Formspree** (free tier supports email + Google Sheets via Zapier integration) or **Web3Forms** (free tier sends email directly), then global find-and-replace `[TBD-form-endpoint]` site-wide.
- `[TBD-newsletter-endpoint]` — newsletter form action URL on every page. **Intake left blank** at 9.4 (newsletter destination). Action: same as above, or pick **Mailchimp / Brevo / Zoho Campaigns** and replace.
- `[TBD-map-embed]` — only in an **HTML comment** on contact.html now. The iframe `src` is wired to a working Google Maps `q=` URL. Replace the comment + iframe with the official Embed-API URL once the client creates their Google Business Profile (intake said "create").

## Intake fields left blank / pending

These were intake fields the client did not fill — site hides them gracefully or shows tasteful placeholder copy:

- **Founder story** (intake 3.3) — client wrote "whatsapp", will send story over WhatsApp. The about-page line "Founded in 2017 by Neelambar Vadrevu. Built for Indian business owners…" stands as a stub until the longer story arrives.
- **Team members 2-4 roles / photos / LinkedIn** (intake 3.4a–3.7c) — slot 2 has Radhika's name but role is blank; slots 3–4 show "Profile updating soon".
- **Testimonials 1-5** (intake 4.6.1–4.6.5) — all blank. Site shows: "Client stories are published only after we have written permission. We are collecting these from clients we have worked with since 2017. New testimonials publish here in the weeks ahead." with name "Coming soon" and type "Real client stories pending".
- **Social links** (intake 5.x) — LinkedIn and Instagram marked "create". Other platforms blank. Footer + offcanvas social icons still point to `#`.
- **Blog articles** (intake 7.x) — all 5 article Y/N approvals left blank. Blog cards show placeholder titles with dates 15 Jul–19 Aug 2026.
- **Visual assets** (intake §8) — none of the 6 visual-asset checkboxes ticked. Client said "photos shared by 05/07/2026". Hero, about, news, project, team, brand carousel still template stock.
- **Photos shared by** — 05/07/2026 deadline.

When any of these arrive, search for the matching pattern (`<a href="#">` for social, "Coming soon" / "Profile updating soon" for team and testimonials, `assets/img/inner-page/team-*` for team photos) and swap in.

## Auto-sync workflow (READ THIS BEFORE MARKING ITEMS DONE)
When you complete a checklist item:
1. Edit [production-checklist.md](production-checklist.md) — change `- [ ]` to `- [x]`.
2. Run the sync script: `powershell -ExecutionPolicy Bypass -File .\sync-progress.ps1`
3. The script regenerates the **Progress Snapshot** block below from the checklist.

The Progress Snapshot is auto-generated. Do not edit it by hand — your edits will be overwritten on next sync.

---

<!-- PROGRESS:START -->
## Progress Snapshot
**43 / 115 items complete (37.4%)** - last synced 2026-06-29 12:01

### By section
- **P0 — Cannot launch without these** - 40 / 50 (80%)
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
<!-- PROGRESS:END -->
