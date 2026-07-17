# RequiredFilings.com — Modernisation & Fix Build Plan

> **Purpose:** Master task list for the full site upgrade from ~49/100 audit score to 85+/100.
> **Source prompt:** "Complete Website Fix and Modernisation" brief (2026-07-17).
> **Tick items** `- [x]` when done. Run `.\sync-progress.ps1` after ticking P0/P1 items.

---

## Constraints (never violate without asking)

- WIREFRAME LOCK is in force — do not add/remove/reorder `<section>` blocks. See CLAUDE.md.
- All copy must follow `buyer-file/content-principles.md`.
- UTF-8 safe read/write only (see CLAUDE.md encoding rule).
- Forms must keep Pabbly webhook integration intact.
- Do not rename or delete public `.html` URLs (no redirects exist yet).

---

## Phase 0 — Pre-work: Audit & Safety

- [x] Scan all 20 HTML pages and list every shared structure (header, nav, offcanvas, footer, newsletter CTA, forms, breadcrumbs, accordions, buttons)
- [x] Inventory all CSS files (12 files) and JS files (27 files) — record usage per page
- [x] Search for duplicate IDs across all pages (especially `id="contact-form"`)
- [x] Search for broken or empty links (`href="#"` used for real destinations)
- [ ] Search for invalid HTML: mismatched tags, buttons inside links, empty headings
- [ ] Search for missing accessibility attributes across all pages
- [x] Search for inconsistent contact details (phone, hours, address)
- [x] Search for outdated dates (copyright year, effective dates)
- [x] Create a git checkpoint / tag before major edits: `git tag pre-modernisation`

---

## Phase 1 — Critical Technical Bug Fixes

### 1.1 Form handler conflict on contact.html
- [x] Inspect `contact.html` for simultaneous loading of `ajax-mail.js` and `form-handler.js`
- [x] Determine which script is the live Pabbly webhook handler
- [x] Remove the obsolete handler
- [x] Ensure single submit listener, no double-submit, button disabled during submission
- [x] Verify success/error messages still display
- [x] Verify network-failure path shows a useful message

### 1.2 Duplicate form IDs
- [ ] Search all pages for `id="contact-form"` duplicates
- [ ] Rename to meaningful unique IDs: `primary-contact-form`, `service-enquiry-form`, `footer-enquiry-form`
- [ ] Add shared `data-enquiry-form` attribute for JS selectors
- [ ] Update all JS selectors that reference the old IDs

### 1.3 Homepage smooth-scroll wrapper
- [ ] Confirm `rf-scroll-wrapper` / `rf-scroll-content` divs wrap the correct content in `index.html`
- [ ] Fix any premature closing tags inside the wrapper
- [ ] Verify header and footer behave correctly outside/inside the wrapper
- [ ] Confirm anchor links still work after fix
- [ ] Confirm no horizontal overflow introduced
- [ ] Confirm mobile scrolling is native (ScrollSmoother disabled on mobile)

### 1.4 Structural HTML errors
- [ ] Validate `index.html` — fix all errors
- [ ] Validate `contact.html` — fix all errors
- [ ] Validate `start-a-business.html` — fix all errors
- [ ] Validate all 10 service-detail pages — fix all errors
- [ ] Validate `about.html`, `services.html`, `blog.html` — fix all errors
- [ ] Validate legal pages (privacy, terms, refund, disclaimer) — fix all errors
- [ ] Validate `404.html` — fix all errors

### 1.5 Working-hours inconsistency
- [x] Standardise to "Monday–Saturday, 10:00 AM–6:00 PM IST" everywhere
- [x] Update: contact page, footer, offcanvas, Schema markup, contact cards
- [x] Remove any "7:00 PM" references

### 1.6 Copyright year
- [x] Replace hardcoded year with `<span data-current-year>2026</span>` pattern on every page
- [x] Add lightweight inline script to update `data-current-year` spans on page load

### 1.7 Incorrect phone icon
- [x] Replace every `fa-phone-xmark` with `fa-phone` (or consistent call SVG)
- [ ] Audit: one phone icon style, one WhatsApp icon, one email icon, one location icon sitewide
- [x] Add `aria-hidden="true"` to all purely decorative icons
- [ ] Add `aria-label` to all icon-only buttons/links

### 1.8 Dead address links
- [x] Replace every `href="#"` on address/contact elements with real Google Maps URL
- [x] Add `target="_blank" rel="noopener noreferrer"` where needed
- [ ] Provide accessible title or descriptive text on map links

### 1.9 Blog page — remove from primary navigation
- [x] Remove "Blog" from main nav (`<nav>`) on every page
- [x] Remove "Blog" from offcanvas mobile nav on every page (auto-removed: offcanvas menu populated from main nav via meanmenu JS)
- [x] Keep "Blog" only in footer (label as "Blog — Coming Soon") or remove entirely
- [x] Add `<meta name="robots" content="noindex, follow">` to `blog.html` (already has noindex? — verify)
- [x] Preserve `blog.html` file for future use

### 1.10 Accessibility labels — global pass
- [x] Add `aria-label="Close navigation menu"` to offcanvas close buttons
- [x] Add `aria-label="Open navigation menu"` to hamburger triggers (converted sidebar__toggle div to button)
- [x] Add `aria-label="Call RequiredFilings"` to phone links — all phone links have visible text; mobile bar link already has aria-label. No bare icon-only phone links remain.
- [x] Add `aria-current="page"` to active nav items on all 14 pages with nav links
- [x] Add `aria-current="page"` to active breadcrumb items (last breadcrumb `<li>` on each page — wrapped in `<span aria-current="page">` on 19 inner pages)
- [ ] Ensure dropdown `<button>` elements expose `aria-expanded` state

---

## Phase 2 — Design System: CSS Variables & Tokens

### 2.1 Colour system
- [ ] Audit current `--theme` through `--theme6` usage in `main.css` and `color.css`
- [ ] Define new brand token set in `:root` (primary-900 → primary-600, accent-600, neutrals, semantic tokens)
- [ ] Map old `--theme*` references to new tokens (find+replace in `main.css`)
- [ ] Remove pink as a major brand colour
- [ ] Remove unnecessary orange/yellow accents
- [ ] Verify WCAG AA contrast for all foreground/background combinations
- [ ] Define semantic aliases: `--surface-page`, `--surface-subtle`, `--surface-dark`, `--text-primary`, `--text-secondary`, `--text-inverse`, `--border-default`, `--action-primary`, `--action-primary-hover`, `--focus-ring`

### 2.2 Typography
- [ ] Confirm Inter is the primary font (remove Public Sans if not needed)
- [ ] Define `clamp()`-based type scale: `--font-size-display` through `--font-size-small`
- [ ] Apply scale to h1–h4 and body selectors in `main.css`
- [ ] Set body line-height 1.65–1.75
- [ ] Set max line-length on body copy (~70ch)
- [ ] Audit heading hierarchy on every page — fix H1 > H2 > H3 violations
- [ ] Add letter-spacing for uppercase text only
- [ ] Remove font-family declarations that serve no visual distinction

### 2.3 Spacing system
- [ ] Define `--space-1` through `--space-10` scale in `:root`
- [ ] Replace arbitrary margin/padding values in `main.css` with scale tokens where safe
- [ ] Create section rhythm variants: compact / standard / large / hero
- [ ] Ensure adjacent sections alternate rhythm (avoid identical stacked blocks)

### 2.4 Container widths
- [ ] Define `--container-sm` (720px), `--container-md` (960px), `--container-lg` (1200px), `--container-xl` (1360px)
- [ ] Apply appropriate container to text-heavy sections to cap line length
- [ ] Ensure hero inner container stays readable at ultrawide

### 2.5 Border radius, borders, shadows
- [ ] Define `--radius-sm` (6px), `--radius-md` (12px), `--radius-lg` (18px), `--radius-pill` (999px)
- [ ] Standardise card and button radius using these tokens
- [ ] Remove heavy drop-shadows; use fine borders or whitespace instead
- [ ] Remove neumorphism/glow effects if present

---

## Phase 3 — Header & Navigation

### 3.1 Unify header markup
- [ ] Identify all header variants across 20 pages
- [ ] Create one canonical header HTML and apply consistently to every page
- [ ] Standardise: logo size, nav order, CTA button, hamburger trigger, breakpoint behaviour

### 3.2 Fix responsive breakpoint gap (1200px–1399px)
- [ ] Test at 1024px, 1180px, 1200px, 1280px, 1366px, 1399px, 1440px
- [ ] Fix `d-none d-xxl-block` / `d-xl-none` collision so nav is never invisible
- [ ] Document the breakpoints used for desktop vs mobile nav switch

### 3.3 Active navigation states
- [ ] Add visible active state (font-weight + underline or indicator) using `aria-current="page"`
- [ ] Ensure active state works at both desktop and mobile breakpoints

### 3.4 Header CTA hierarchy
- [ ] Make primary header CTA unambiguous ("Talk to a Filing Expert" or approved copy)
- [ ] Demote secondary phone/WhatsApp to smaller treatment
- [ ] Remove visual equality between competing actions

### 3.5 Mobile navigation
- [ ] Ensure menu opens/closes with Escape key
- [ ] Implement focus trap while offcanvas is open
- [ ] Restore focus to hamburger trigger when offcanvas closes
- [ ] Prevent body scroll while menu is open
- [ ] Confirm all touch targets ≥ 44×44 CSS pixels
- [ ] Remove dead links from mobile nav (Blog)
- [ ] Show active page state in mobile nav

---

## Phase 4 — Homepage

### 4.1 Hero section
- [ ] Confirm hero copy: one headline, one supporting para, primary CTA, secondary CTA, ≤3 trust points
- [ ] CTA hierarchy: Primary = "Talk to a Filing Expert", Secondary = "Explore Services", Optional text = "Chat on WhatsApp"
- [ ] Remove any fourth/fifth CTA from above the fold

### 4.2 Replace template hero assets
- [ ] Remove `hero-1.png`, `box1.png`, `box2.png`, generic SaaS dashboard imagery
- [ ] Plan replacement visual (filing-status diagram / compliance calendar / India-context document collage)
- [ ] Note: until replacement art is ready, use clean solid/gradient background rather than broken template imagery

### 4.3 Reduce decorative star SVG repetition
- [ ] Audit how many times `<img … star*.svg>` or inline star appears above section headings
- [ ] Keep only on high-priority sections; remove from routine section headers
- [ ] Use typography and whitespace for hierarchy on the rest

### 4.4 Improve section rhythm
- [ ] Audit current homepage section order
- [ ] Confirm removal of testimonial-section, news-section, brand-section (already done per CLAUDE.md)
- [ ] Introduce variety: open/spacious → dense-info → split-layout → proof → CTA pattern

### 4.5 Replace meaningless marquees
- [ ] Replace generic single-word marquee ("Registration / Filings / Compliance") with real proof stats
- [ ] Use confirmed numbers only: 10,800+ filings, 98% on time, 26+ Pvt Ltd, 87+ MSME, 4+ ISO
- [ ] Evaluate replacing marquee with a static proof strip if it looks cleaner

### 4.6 Services section cards
- [ ] Ensure each card has: service name, one-sentence explanation, relevant icon, CTA, consistent height
- [ ] Add meaningful hover state (not just colour shift)

### 4.7 Project/Recent Filings section
- [ ] Rename section if it doesn't show actual filing work
- [ ] Replace cityscapes/generic stock with real compliance scenarios or anonymised case cards
- [ ] Format: Problem → Action → Outcome (three-sentence cards)

---

## Phase 5 — About Page

### 5.1 Hero/founder imagery
- [ ] Note that `about-image.jpg` was replaced with AI-generated office image — flag for client real photo replacement
- [ ] If stock: use restrained typographic layout instead of fake-looking image

### 5.2 "How We Work" section
- [ ] Redesign into 3–4 step process: Tell us → Share docs → We file → You receive confirmation
- [ ] Each step: number + short heading + one-line explanation + optional minimal icon
- [ ] Remove excess vertical padding from one-sentence + one-CTA version

### 5.3 Heading hierarchy audit
- [ ] Confirm one H1 on about page
- [ ] FAQ/accordion items use `<button>` triggers (not heading tags) — verify
- [ ] No H2 visually equal to or above the H1

---

## Phase 6 — Services Overview Page (services.html)

### 6.1 Group services into categories
- [ ] Add category sub-headings: "Start and Register" / "Protect and Operate" / "Stay Compliant"
- [ ] Map 10 services to appropriate groups
- [ ] Verify card grid still matches wireframe column layout after grouping text is added

### 6.2 Repair empty contact-section left column
- [x] Audit current state of the contact section's left column
- [x] Option A: Fill with trust headline + 3 benefits + response-time statement + phone + WhatsApp
- [x] Option B: Remove empty column and centre form in narrower container
- [x] Choose the stronger-looking option and implement (chose Option A — trust block added)

---

## Phase 7 — Service Detail Pages (10 pages)

> Apply consistently to: start-a-business, gst-services, tax-services, roc-compliance, ipr, iso-certification, msme-zed, accounting, statutory-registrations, licenses

### 7.1 Add orientation content above service grid
- [x] Add descriptive H1 + 1–2 sentence intro on every service page (not just the breadcrumb title)
- [x] Verify H1 is descriptive: "GST Registration and Return Filing Services" not "GST Services"

### 7.2 Standardise service page structure
- [ ] Each page should follow: Hero → Trust indicators → What it is → Who needs it → Consequences → What we handle → Documents → Timeline → Process → FAQ → Enquiry form
- [ ] Pages may omit sections where content does not exist, but order must be consistent

### 7.3 Contextual form pre-selection
- [x] On each service page, pre-select the relevant service in the enquiry dropdown via `selected` attribute
- [x] GST page → GST Services; ROC page → ROC Compliance; IPR page → Intellectual Property; etc.
- [x] User must still be able to change selection

### 7.4 Contact section — fill empty left column
- [x] Add contextual trust copy: "Need help with [service]? Tell us what stage you're at. A filing specialist will explain the next step."
- [x] Add 3 trust points: Clear document checklist / Transparent next steps / Human support on phone or WhatsApp
- [x] Replace generic filler text everywhere

---

## Phase 8 — Contact Page (contact.html)

### 8.1 Contact cards audit
- [ ] Verify all 5 contact card types work: Visit, Call, Email, Hours, WhatsApp
- [ ] Remove any `fa-phone-xmark` icon from call card
- [ ] Confirm `href="tel:+919502715353"`, `href="mailto:srivaarahi.gst@srivaarahi.com"`, WhatsApp URL

### 8.2 Form UX improvements
- [ ] Confirm all inputs have visible `<label>` elements (not just placeholders)
- [ ] Add required indicators
- [ ] Add inline validation with error messages
- [ ] Ensure submit button has disabled state during submission
- [ ] Add privacy reassurance line: "Your details are used only to respond to your enquiry."
- [ ] Add expected response time statement if operationally accurate

### 8.3 Remove animation from essential controls
- [ ] Verify submit button is NOT hidden by WOW.js / ScrollTrigger before scroll
- [ ] Verify form inputs are immediately visible without scroll
- [ ] Ensure success/error messages are never hidden by animation timing

### 8.4 Map accessibility
- [x] Add `title="RequiredFilings office location"` to map iframe
- [x] Add plain-text address and "Open in Google Maps" link adjacent to map

---

## Phase 9 — Persistent Contact Actions

### 9.1 Floating WhatsApp button
- [x] Confirm existing floating WhatsApp button exists and is styled
- [x] Position: bottom-right, above mobile browser chrome
- [x] Does not overlap form buttons, cookie notice, back-to-top button
- [x] Uses WhatsApp green only for this one element
- [x] `aria-label="Chat with RequiredFilings on WhatsApp"`
- [x] Desktop tooltip on hover
- [x] Pre-filled message: "Hello RequiredFilings, I would like help with a business filing."
- [x] URL-encode the message in the href

### 9.2 Mobile contact bar
- [x] Add fixed bottom bar on mobile: Call + WhatsApp (+ optional Enquire)
- [x] Only visible below ~768px
- [x] Touch targets ≥ 44px
- [x] `padding-bottom: env(safe-area-inset-bottom)` for iPhone notch
- [x] Page content has sufficient bottom padding to not be obscured

---

## Phase 10 — Images & Visual Assets

### 10.1 Remove unrelated template imagery
- [ ] Audit all `<img>` src values — flag generic cityscapes, construction, SaaS dashboards
- [ ] List images still using template stock: project marquee (project-1.jpg–6.jpg), hero-1.png, hero foreground assets, various feature images
- [ ] Note for client: these need replacement photography or illustration

### 10.2 Image optimisation — all pages
- [ ] Add `width` and `height` attributes to every `<img>` (prevents CLS)
- [x] Add `loading="lazy"` to all below-the-fold images
- [x] Add `decoding="async"` to non-critical images
- [x] Do NOT lazy-load LCP hero image (hero-1.png and client-img.png on index.html kept eager)
- [ ] Convert large JPEGs to WebP (deferred from production-checklist — attempt now or document why deferred)

### 10.3 Alt text audit
- [ ] Sweep all pages for `alt=""` on informative images — replace with descriptive text
- [ ] Sweep for `alt="image"` or `alt="about image"` — replace with meaningful description
- [ ] Decorative images get `alt=""`

---

## Phase 11 — Motion & Animation

### 11.1 Remove or replace WOW.js
- [ ] Audit which elements use `wow animated` classes
- [ ] Rebuild critical reveal animations as GSAP ScrollTrigger
- [ ] Remove `wow.min.js` and `animate.css` from pages where WOW.js is no longer used
- [ ] Keep `animate.css` only if referenced by remaining code

### 11.2 Reduced motion support
- [x] Add `@media (prefers-reduced-motion: reduce)` block to `main.css`
- [x] Disable or minimise: smooth scrolling, parallax, marquee animation, animated counters, large entrance animations
- [x] Ensure all content is readable and usable without any motion

### 11.3 Animation principles — audit custom.js / main.js
- [ ] Remove or tighten animations with duration > 700ms for section reveals
- [ ] Remove looping or floating idle animations (distraction risk)
- [ ] Ensure ScrollTrigger instances are refreshed on resize
- [ ] Ensure mobile orientation change does not break layout
- [ ] Ensure no content starts invisible without a guaranteed animation completion path

---

## Phase 12 — Performance

### 12.1 JS dependency audit
- [ ] For each of the 27 JS files — record: pages needing it, file size, blocking/async, used features
- [ ] Candidates for removal: `wow.min.js`, `parallaxie.js`, `jquery.magnific-popup.min.js`, `jquery.counterup.min.js`, `jquery.waypoints.js`, `jquery.nice-select.min.js`
- [ ] Candidates for conditional loading: `swiper-bundle.min.js` (only on carousel pages), `ScrollSmoother.min.js` (homepage only)
- [ ] Remove each only after confirming no usage remains

### 12.2 Page-specific script loading
- [ ] Legal pages (privacy, terms, refund, disclaimer): load only Bootstrap + nav JS + minimal custom
- [ ] 404 page: same as legal pages
- [ ] Contact page: form handler + minimal custom only (no Swiper, no SplitText)
- [ ] Homepage: full bundle
- [ ] Service pages: accordion + form handler + basic animations

### 12.3 Script loading attributes
- [x] Add `defer` to non-critical scripts where execution order allows (all scripts already at end of body — defer has no effect; body-end placement is equivalent)
- [x] Do not use `async` for scripts that depend on jQuery or each other
- [x] Move render-blocking scripts out of `<head>` where safe (all scripts already in body)

### 12.4 CSS cleanup
- [x] Confirm `dark-mode.css` is unused (dark mode removed) — remove from all pages
- [x] Confirm `rtl.css` is unused (RTL not supported) — remove from all pages
- [ ] Remove unused template component CSS that has no live HTML counterpart
- [ ] Consolidate duplicate rule declarations in `main.css`

### 12.5 Performance targets (document current state first)
- [ ] Run Lighthouse on index.html, contact.html, one service page — record baseline
- [ ] After fixes: aim for mobile Lighthouse Performance ≥ 80, Accessibility ≥ 95, Best Practices ≥ 95, SEO ≥ 95
- [ ] LCP < 2.5s, CLS < 0.1, INP < 200ms

---

## Phase 13 — Accessibility (WCAG 2.2 AA)

### 13.1 Keyboard navigation
- [ ] Test full site navigation by keyboard only (Tab, Shift+Tab, Enter, Space, Escape, Arrow keys)
- [ ] Fix any keyboard trap (only expected trap: open offcanvas menu)
- [ ] Ensure accordions respond to Enter and Space
- [ ] Ensure Escape closes offcanvas, dropdowns, popups

### 13.2 Focus styles
- [x] Remove any `outline: none` without accessible replacement
- [x] Add consistent `:focus-visible` ring to all interactive elements
- [x] Style: `outline: 3px solid var(--focus-ring); outline-offset: 3px;`
- [x] Apply to: links, buttons, inputs, selects, textareas, accordion controls, menu controls

### 13.3 Form accessibility
- [x] Every field has an associated `<label>` (not just placeholder) — visually-hidden labels on all inputs/selects; `for` attribute ties label to field
- [ ] Error messages associated with fields via `aria-describedby`
- [ ] Required fields: use `required` attribute + visible asterisk with legend
- [ ] Error indicators: colour + icon/text (not colour alone)
- [ ] Success messages: receive focus or announced via `aria-live`
- [x] Honeypot fields: `aria-hidden="true"` + `tabindex="-1"` — already implemented on contact + service forms
- [x] `autocomplete` attributes: `name`, `email`, `tel` — already on all contact/service forms

### 13.4 Colour contrast audit
- [ ] Test all body text, link, button, placeholder, form border, disabled state colours
- [ ] Test text over images in hero and CTA newsletter sections
- [ ] Fix all AA failures

### 13.5 Semantic structure
- [x] Add `<a class="skip-link" href="#main-content">Skip to main content</a>` as first child of `<body>` on every page
- [x] Add `<main id="main-content">` wrapper on every page (implemented as `id="main-content"` on `rf-scroll-content` div — avoids wireframe restructuring)
- [ ] Verify `<header>`, `<nav>`, `<main>`, `<footer>` used correctly on every page
- [ ] Verify `<section>` elements have accessible names where needed

---

## Phase 14 — SEO & Structured Data

### 14.1 Page metadata — final verification pass
- [ ] Every page has unique `<title>` — verify no two titles are the same
- [ ] Every page has unique `<meta name="description">` — verify uniqueness
- [ ] Every page has correct canonical URL
- [ ] Every page has `lang="en"` on `<html>`

### 14.2 Service page H1/title alignment
- [ ] Confirm each service page title, H1, and main content describe the same service
- [ ] No keyword stuffing in titles or H1s

### 14.3 FAQ structured data
- [ ] Identify pages with genuine Q&A content (not "how it works" process steps)
- [ ] Add `FAQPage` JSON-LD only where real Q&A is visibly on the page
- [ ] Generate schema from actual visible content (no divergence from page text)

### 14.4 Local business data consistency
- [ ] Cross-check phone, email, address, hours across: website, footer, contact page, Schema JSON-LD
- [ ] Ensure Schema `openingHours` matches visible hours text

---

## Phase 15 — Legal & Utility Pages

### 15.1 Legal pages (privacy, terms, refund, disclaimer)
- [ ] Apply narrow reading container (~720px max-width)
- [ ] Remove Swiper, parallax, SplitText, WOW.js from legal page script bundles
- [ ] Add table of contents for pages longer than 3 sections
- [ ] Verify effective dates are current and accurate

### 15.2 404 page
- [ ] Verify `noindex` meta present
- [ ] Verify CTAs: Home, Contact, Popular services
- [ ] Remove heavy illustration dependency if present
- [ ] Load only essential scripts (Bootstrap + nav + minimal custom)

---

## Phase 16 — Component Standardisation

### 16.1 Button system
- [ ] Define: Primary, Secondary, Text-link, Icon-button, WhatsApp action
- [ ] Standardise: height, padding, radius, icon-spacing, font-weight, hover, active, focus, disabled, loading states
- [ ] Apply consistently across all pages

### 16.2 Accordion system
- [x] One icon convention: plus (closed) → minus (open) — index.html arrow changed to plus; all 4 pages now consistent
- [x] Every trigger is a `<button>` with `aria-expanded` and `aria-controls`
- [x] Unique panel IDs on every page (`acc-btn-N` / `acc-panel-N`)
- [ ] Keyboard: Enter/Space toggles, no layout jump on open/close — verify in browser

### 16.3 Card system
- [ ] Define reusable variants: Service card, Proof card, Contact card, Case-study card, Process card
- [ ] Each variant has consistent spacing, radius, hover state, and height behaviour

### 16.4 Form system
- [ ] Standardise: input height, border colour, focus state, error state, success state, required indicator
- [ ] One consistent dropdown design (NiceSelect or native — pick one)
- [ ] One consistent submit button style per form context

### 16.5 Section header system
- [ ] Define: centred, left-aligned, light-on-dark, compact variants
- [ ] Reduce star-decoration usage to ≤ 30% of section headers
- [ ] Remaining headers use typography + whitespace hierarchy only

---

## Phase 17 — Responsive Design QA

For every page, test at: 320px / 360px / 390px / 414px / 768px / 1024px / 1280px / 1366px / 1440px / 1920px

- [ ] No horizontal overflow at any breakpoint on any page
- [ ] No clipped headings at narrow widths
- [ ] No overlapping fixed controls (WhatsApp button, mobile contact bar, back-to-top)
- [ ] All tap targets ≥ 44px on mobile
- [ ] No awkward single-word orphans on headings at 360px
- [ ] Footer is readable at 360px
- [ ] Breadcrumb wraps gracefully on mobile
- [ ] Navigation never invisible at any width (Phase 3.2 fix verified here)

---

## Phase 18 — Final QA Pass

### 18.1 Functional testing (every page)
- [ ] Primary navigation + dropdown — all links resolve
- [ ] Mobile offcanvas — opens, closes, all links resolve
- [ ] Phone `tel:` links work
- [ ] WhatsApp link opens correct number with pre-filled message
- [ ] Email `mailto:` links work
- [ ] Google Maps link opens correct location
- [ ] All forms submit without duplicate handler conflict
- [ ] Accordion open/close
- [ ] CTA links resolve to correct destination
- [ ] Back-to-top button works
- [ ] Internal links on each page are correct
- [ ] 404 page loads for unknown URLs

### 18.2 Browser testing
- [ ] Chrome (latest)
- [ ] Edge (latest)
- [ ] Firefox (latest)
- [ ] Mobile Chrome (Android)
- [ ] Mobile Safari (iOS) if device available

### 18.3 Console check
- [ ] Zero unexplained JS errors on every page
- [ ] Zero 404 network requests for CSS/JS/image assets
- [ ] No mixed-content warnings

### 18.4 HTML/CSS validation
- [ ] Run W3C HTML validation on every page — fix all errors
- [ ] Run W3C CSS validation on `main.css` — fix errors (warnings acceptable)

---

## Completion Criteria

The build is done when ALL of the following are true:

- [ ] No duplicate form handler on any page
- [ ] No duplicate element IDs on any page
- [ ] No malformed HTML on any page
- [ ] Contact info consistent: phone / email / hours across all pages + Schema
- [ ] Blog absent from primary nav on all pages
- [ ] Mobile nav works at every breakpoint (no disappearing at 1200–1399px)
- [ ] Site has unified canonical header + footer
- [ ] `fa-phone-xmark` replaced everywhere
- [ ] Homepage scroll wrapper is valid HTML
- [ ] Empty contact-section columns filled or removed
- [ ] Service pages have orientation headings above grids
- [ ] Service enquiry forms pre-select contextual service
- [ ] WhatsApp persistently accessible (floating button + mobile bar)
- [ ] Colour system simplified to brand tokens
- [ ] Template stock imagery removed from critical positions
- [ ] Essential controls (submit buttons, form fields) never hidden by animation
- [ ] WOW.js removed or specifically justified for each remaining usage
- [ ] `dark-mode.css` and `rtl.css` removed from all page loads
- [ ] Every interactive element has visible keyboard focus state
- [ ] `prefers-reduced-motion` support in place
- [ ] Forms functional with Pabbly webhook integration intact
- [ ] Zero major console errors
- [ ] Zero horizontal overflow
- [ ] Core pages meet WCAG AA contrast

---

## Deliverables Checklist

After implementation, produce a structured report with:

- [ ] Executive summary (fixed / redesigned / removed / retained)
- [ ] Complete list of modified files with short description of changes
- [ ] Critical bugs fixed list
- [ ] Design-system token documentation
- [ ] Performance before/after (Lighthouse scores)
- [ ] Accessibility improvements list
- [ ] Page-by-page verification table
- [ ] Remaining recommendations (must-do before launch / recommended / optional future)
