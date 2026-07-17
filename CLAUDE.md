# RequiredFilings.com — Project Context

## What this is
Production website for RequiredFilings.com, a compliance and filing services company in India (company registration, statutory filings, GST, tax, ROC, IPR, ISO, MSME, accounting).

The site is built on top of the Brevon HTML template. 15 pages live as flat HTML in [required-filings/](required-filings/). The template is mostly in place; the real work is replacing template content, branding, and stubs with production content per the content principles.

## Source files
- **Checklist (source of truth):** [production-checklist.md](production-checklist.md)
- **Modernisation build plan:** [build.md](build.md) — 18-phase fix & redesign checklist targeting 85+/100 audit score; tick items there as they complete
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
The wireframe is **locked** as of 2026-06-11, updated 2026-06-29 (preloader + pricing-section removed), updated 2026-07-17 (testimonials, home news section, color-switcher, search popup, header search buttons, offcanvas + footer + team-card social icons all removed).
- **Do not add, remove, reorder, or restructure top-level sections** (`<section>` blocks, header, footer, hero, brand carousel, service grid, about, feature slider, project marquee, FAQ accordion, marquee-2, CTA newsletter, offcanvas).
- **Removed by owner (2026-06-29) — do not reintroduce without asking:** preloader (`<div id="preloader">`), pricing-section (`<section class="pricing-section">` — was on home + 9 service pages).
- **Removed by owner (2026-07-17) — do not reintroduce without asking:**
  - Testimonials — `<section class="testimonial-section">` on `index.html` and `<section class="testimonial-section-3">` on `about.html`. Reason: no real client permissions yet. Reintroduce only when real testimonials land.
  - Home "Latest news" — `<section class="news-section">` removed from `index.html` because there are no real blog posts yet. On `blog.html` the section container is kept but the fake card grid is replaced with a clean "Articles publishing soon" empty state.
  - Color-switcher widget — `<div class="color-palate">` (Dark Mode / Light Mode toggle) removed on every page.
  - Search popup — `<div class="search-popup">` on every page + both header `search-toggler` buttons.
  - Social icons — offcanvas social row, footer social row, all team-card social overlays, and team-card LinkedIn overlays. Reason: no social accounts exist yet. Reintroduce only when real URLs are supplied.
  - Team section — `<section class="team-section-3">` removed from `about.html`. Reason: only two of four slots had real people (founders — already introduced in the founder story above); slots 3–4 were "Profile updating soon" placeholders.
  - Brand carousel — `<div class="brand-section">` (6-logo swiper) removed from `index.html`, `about.html`, `services.html`, and the 8 service pages. Reason: no real client logos exist yet. Reintroduce only when real logos land.
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
| Office / registered address | 1-3-183/40/A/B, Flat #101, Plot #34, Udaya Aditya Apts, Gandhinagar, Hyderabad, Telangana - 500080 |
| Office landmark (contact page only) | Opposite Samrakshana School, next to Akshaya Fertility Clinic |
| Jurisdiction city | Hyderabad |
| Working hours | Mon–Sat, 10:00–18:00 IST |
| Legal entity | Sri Vaarahi Computer Services Pvt. Ltd. |
| CIN | U72900TG2017PTC118162 |
| GSTIN | 36AAYCS9154Q1ZZ |
| Founders | Neelambar Vadrevu (Co-Founder & Managing Director), Radhika Vadrevu (Co-Founder & Director) |
| Year founded | 2017 |
| Filings completed | 10,800 |
| On-time rate | 98% |
| Active clients | 127 (not shown publicly per intake — kept for internal reference) |
| Authorised capital threshold | ₹1,00,000 |
| Pricing | Every service tier set to "On request" (client opted not to publish rupee amounts) |
| Case studies | Filled with intake numbers — 26+ Pvt Ltd incorporations / 10–15 GST notice resolutions / 87+ Udyam + 4+ ISO certifications |
| Map embed | Address-based Google Maps `q=` URL on contact.html (works without an API key) |
| Team slot 1 | Neelambar Vadrevu, Co-Founder & Managing Director |
| Team slot 2 | Radhika Vadrevu, Co-Founder & Director |

## Still pending after intake (TBD tokens that remain)

Only **three** TBD tokens still appear in the codebase, all blocked on infra decisions:

All TBD tokens were resolved on 2026-07-17:
- `[TBD-form-endpoint]` — resolved. All 10 contact-form `action` attributes now point at the Pabbly webhook (`https://connect.pabbly.com/webhook-listener/webhook/IjU3NjAwNTY5MDYzNzA0M2Qi_pc/IjU3NjcwNTY5MDYzNTA0MzM1MjZhNTUzMDUxMzQi_pc`). Pabbly workflow must be configured client-side to route to (a) fixed email inbox and (b) Google Sheets, per intake.
- `[TBD-newsletter-endpoint]` — resolved. All 19 newsletter-form `action` attributes now point at the same Pabbly webhook. Same routing rules apply.
- `[TBD-map-embed]` — resolved. `contact.html` iframe now points at "Udaya Aditya Apartments, Gandhinagar, Hyderabad, Telangana 500080" via Google Maps `q=` URL at zoom 17. Upgrade to official Embed-API URL once Google Business Profile is created.

## Intake fields left blank / pending

These were intake fields the client did not fill — site hides them gracefully or shows tasteful placeholder copy:

- **Founder story** (intake 3.3) — rewritten 2026-07-17. Current copy on `about.html`: two-decade MNC experience → founded RequiredFilings for MSMEs in 2017. Replace with client's longer WhatsApp version when it arrives.
- **Team members 3-4 roles / photos / LinkedIn** (intake 3.6–3.7c) — slot 1 (Neelambar) and slot 2 (Radhika) now confirmed. Slots 3–4 still show "Profile updating soon".
- **Testimonials 1-5** (intake 4.6.1–4.6.5) — all blank. **Section removed 2026-07-17** from home + about per owner instruction. Reintroduce when real permissions land.
- **Social links** (intake 5.x) — no accounts yet. **All social icons removed 2026-07-17** (offcanvas, footer, team-card overlays, LinkedIn overlays). Reintroduce when URLs are supplied.
- **Blog articles** (intake 7.x) — all 5 article Y/N approvals left blank. **Home news section removed 2026-07-17**; `blog.html` shows a clean "Articles publishing soon" empty state.
- **Visual assets** (intake §8) — client "photos shared by 05/07/2026" deadline missed. As of 2026-07-17 the 5 highest-impact image slots were replaced with AI-generated India-context photography via Higgsfield `soul_location`:
  - `assets/img/breadcrumb-bg.jpg` — Indian city skyline at golden hour (used on 19 inner pages as banner background)
  - `assets/img/inner-page/about-image.jpg` — Indian office interior (about page inner hero)
  - `assets/img/og-share.jpg` — deep teal + warm gold abstract (all pages' Open Graph share image)
  - `assets/img/home-1/hero/hero-bg.jpg` — reused breadcrumb-bg (soul_location baked hallucinated location text into the original hero attempt; substituted with the clean skyline until credits refresh)
  - `assets/img/home-1/cta-newsletter.jpg` — reused og-share (same reason as hero-bg)
  - Follow-up: regenerate `hero-bg.jpg` and `cta-newsletter.jpg` with unique clean prompts (try `recraft_v4_1` model — no location-caption artifact) once credits are available. Also still template stock: project marquee (`project-1.jpg`–`project-6.jpg`), home-1/hero foreground assets (`hero-1.png`, `client-img.png`, `box1.png`, `box2.png`), and various feature/service inline images.

## SEO plumbing (added 2026-07-17)

Added in one pass:

- `robots.txt` at site root — allows all crawlers, points at sitemap.
- `sitemap.xml` at site root — 19 URLs with lastmod, changefreq, priority.
- `<link rel="canonical">` on every page — points at the production URL (home canonical strips `index.html`).
- Open Graph + Twitter card meta on every page — `og:type`, `og:site_name`, `og:title`, `og:description`, `og:url`, `og:image` (1200x630), `og:locale=en_IN`; `twitter:card=summary_large_image` + title/description/image.
- JSON-LD Schema.org:
  - Home: `Organization` (founders, CIN, GSTIN, address, contactPoint) + `LocalBusiness` (hours, priceRange, areaServed).
  - Contact: `LocalBusiness` + `BreadcrumbList`.
  - Each of 10 service pages: `Service` (serviceType, description, provider, areaServed) + 3-item `BreadcrumbList`.
  - About, services overview, blog, and 4 legal pages: `BreadcrumbList`.
- `404.html` — cloned from `disclaimer.html` chrome, `<meta name="robots" content="noindex, follow">`, self-canonical, "Page not found." breadcrumb + centered CTAs to home + contact + popular pages. Not listed in sitemap.
- Still pending: `FAQPage` schema on pages with FAQ accordions (needs Q&A extraction per page — deferred).

When any of these arrive, search for the matching pattern (`<a href="#">` for social, "Coming soon" / "Profile updating soon" for team and testimonials, `assets/img/inner-page/team-*` for team photos) and swap in.

## Auto-sync workflow (READ THIS BEFORE MARKING ITEMS DONE)
When you complete a checklist item:
1. Edit [production-checklist.md](production-checklist.md) — change `- [ ]` to `- [x]`.
2. Run the sync script: `powershell -ExecutionPolicy Bypass -File .\sync-progress.ps1`
3. The script regenerates the **Progress Snapshot** block below from the checklist.

The Progress Snapshot is auto-generated. Do not edit it by hand — your edits will be overwritten on next sync.

## Modernisation build workflow (READ THIS BEFORE STARTING ANY BUILD PHASE)

[build.md](build.md) is the active modernisation checklist. It is the source of truth for the upgrade from ~49/100 to 85+/100.

**After every successful build step:**
1. Edit [build.md](build.md) — change the completed task's `- [ ]` to `- [x]`.
2. No sync script needed — `build.md` is self-contained and does not mirror into CLAUDE.md.
3. If a phase reveals new issues not yet on the list, add them to the relevant phase section in `build.md` before ticking anything.

**Rule:** Never mark a task `[x]` unless the change is confirmed working in the browser or verified in code. Partial implementations stay `[ ]`.

---

<!-- PROGRESS:START -->
## Progress Snapshot
**64 / 115 items complete (55.7%)** - last synced 2026-07-17 21:04

### By section
- **P0 — Cannot launch without these** - 47 / 50 (94%)
- **P1 — Credibility and SEO** - 15 / 27 (56%)
- **P2 — Polish and QA before launch** - 2 / 33 (6%)
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
<!-- PROGRESS:END -->
