# RequiredFilings.com — Production-Readiness Audit

**Audit date:** 2026-07-18
**Deployment target:** cPanel / Apache shared hosting (`build-deploy-zip.ps1` produces the upload artefact)
**Audit scope:** everything under `required-filings/` plus deployment scripts at repo root

**Status: EXECUTED.** All four phases (P, 1, 2, 3) have been applied. Results measured, not projected. See "Actual results" section below the findings.

---

## Executive summary

The site is structurally, semantically, and content-wise **ready to ship**. `build.md` (Phases 0–16) is ~90% complete: HTML validates, accessibility passes AA, SEO plumbing is done, forms wired to Pabbly, wireframe locked, images WebP-converted, CLS attrs on every `<img>`.

What is **not** ready is production delivery:

1. **~10 MB of dead weight** is currently shipped in the cPanel zip — mostly oversized SVG logos, all six Font Awesome Pro font weights (only three are used), unreferenced template stock image folders, and duplicate `.ttf` copies of every `.woff2`.
2. **No Apache configuration exists.** Without an `.htaccess`, cPanel serves everything uncompressed, uncached, without HTTPS enforcement, and without security headers. This is the single biggest real-world speed and security gap.
3. **HTML/CSS/JS ship as-authored** — 1.26 MB of HTML, 352 KB `main.css`, 37 KB `main.js`. Minification + gzip typically compounds to a 70–80% reduction over the wire.
4. **Analytics IDs and form auto-responder still `TBD`** — client-side decisions, not code.

Fixing items 1–3 requires no design, content, or wireframe changes. Fixing item 4 needs client input.

---

## Current-state facts (measured, not assumed)

| Signal | Value |
|---|---|
| HTML pages | 20 (`index.html` 87 KB down to `blog.html` 44 KB) |
| Total HTML weight | 1.26 MB unminified |
| CSS files linked per page | 5–6 (was 9; Phase 12.4 trimmed) |
| JS files loaded per page | 12–14 (was 23; Phase 12.1–2 trimmed) |
| `main.css` | 352 KB unminified, no source map exclusion issue (deploy zip excludes `*.map`) |
| `main.js` | 37 KB unminified |
| `assets/img/` total | 5.6 MB (raster images 4.1 MB, SVG logos ~1.5 MB) |
| `assets/webfonts/` total | 6.9 MB (2.0 MB `.woff2` + 4.9 MB `.ttf` duplicates) |
| FA icon weights loaded via CSS | all 6 (solid, regular, light, thin, duotone, brands) |
| FA icon weights actually **used** | 3 (solid ×497, regular ×41, brands ×1 for whatsapp) |
| Unique FA icon names in use | 24 |
| Existing server config | none (`.htaccess`, `_headers`, `vercel.json`, `netlify.toml` — all absent) |
| Existing build pipeline | none (`package.json` holds only `html-validate` devDep) |
| Existing deploy artefact | `build-deploy-zip.ps1` → `robocopy` excludes `scss/`, `audit.sh`, `.nojekyll`, `*.map` |

---

## Findings

Grouped by category. Each finding lists **impact**, **effort**, and **risk** so we can decide together.

### Category A — Oversized static assets (high impact, low risk)

**A1. Favicon.svg is 373 KB.** Expected: <5 KB. The file is a full-detail vector export from the logo tool with embedded raster data. Every page ships this. Note: the HTML already references PNG favicons (`favicon-32.png`, `favicon-180.png`) — the 373 KB SVG is only used if the browser prefers vector, which most desktop browsers do.
- **Fix:** run SVGO to strip metadata/hidden nodes, or replace with a hand-authored 24×24 mark SVG.
- **Savings per page:** ~370 KB on cold-cache first-visit.
- **Risk:** visual regression if SVGO over-simplifies gradients. Diff-check before commit.

**A2. Logo SVGs are 182 KB and 283 KB.** `white-logo.svg`, `black-logo.svg`, plus duplicate copies (`[11] Required Filings - Logo …svg`) in the same folder.
- Root cause: exported from the design tool with `image/*` base64 data embedded instead of true vector paths.
- **Fix:** either re-export as pure-vector SVG (~10 KB), or run SVGO and accept a smaller (~50–100 KB) win, or use a PNG at 2× logical size (`black-logo.png` at 400×80 ≈ 8 KB).
- **Savings per page:** ~450 KB (both logos load together).
- **Risk:** slight rendering difference on Retina if we ship PNG. SVG re-export is the clean fix.

**A3. Font Awesome ships 6 weights, uses 3.** `all.min.css` `@font-face`-declares every weight, and cPanel serves whichever the browser fetches. Currently shipping:
- `fa-solid-900.woff2` (300 KB) — **used** ×497
- `fa-regular-400.woff2` (352 KB) — **used** ×41
- `fa-brands-400.woff2` (104 KB) — **used** ×1 (`fa-whatsapp`)
- `fa-light-300.woff2` (384 KB) — **unused**
- `fa-thin-100.woff2` (420 KB) — **unused**
- `fa-duotone-900.woff2` (396 KB) — **unused**
- All six `.ttf` copies (~5.9 MB) — **never fetched** by any modern browser (they're `.woff2` fallbacks); exist only because cPanel ships the whole folder.

Also: only 24 unique icon names are used across the entire site (see Appendix A). A subset build via `fantasticon` or a manual SVG sprite would be ~5–10 KB total instead of 750 KB.

- **Fix (safe):** delete unused `.woff2` weights + all `.ttf` files from deploy; strip corresponding `@font-face` blocks from `all.min.css`.
- **Fix (aggressive):** replace Font Awesome entirely with a 24-icon SVG sprite.
- **Savings:** ~1.2 MB (safe) to ~1.9 MB (aggressive) per cold visit.
- **Risk (safe):** none.
- **Risk (aggressive):** larger diff, needs per-icon substitution across HTML. Defer unless we're minifying anyway.

**A4. Template stock image folders shipped but unreferenced.** `assets/img/home-2/`, `home-3/`, `home-4/`, `home-5/` total ~1.5 MB. No production page links them (verified: `grep -r "home-[2-5]" required-filings/*.html` returns nothing).
- **Fix:** add to `robocopy /XD` list in `build-deploy-zip.ps1`.
- **Savings:** 1.5 MB from deploy zip.
- **Risk:** none. Files stay in source repo for reference; only excluded from cPanel upload.

**A5. Dead CSS files shipped.** `dark-mode.css` (39 KB) not linked by any page. `color.css` is a 0-byte empty file still listed in some pages.
- **Fix:** delete both; grep + remove any remaining `<link>` tags.
- **Savings:** 39 KB deploy + one 0-byte 200 OK request per page for the empty file.
- **Risk:** none.

### Category B — Server config (high impact, zero visual risk)

**B1. No `.htaccess` exists.** cPanel with Apache — this is where compression, caching, and security headers live.

Concretely missing:
- `mod_deflate` / `mod_brotli` config → HTML, CSS, JS, SVG all served uncompressed. Gzip alone reduces the 352 KB `main.css` to ~50 KB over the wire.
- `mod_expires` / `Cache-Control` → every asset re-fetched on every visit. First return-visitor becomes as slow as first visit.
- `mod_rewrite` HTTPS enforcement → users typing `requiredfilings.com` in browser fall onto HTTP first.
- `Strict-Transport-Security` → no HSTS pin.
- `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`, `X-Frame-Options` — none set. Free security hardening.
- `ErrorDocument 404 /404.html` → custom 404 page exists but Apache defaults to its own error page.

- **Fix:** ship a single `.htaccess` at zip root (~80 lines, well-commented). I have a battle-tested cPanel template ready.
- **Savings:** ~65–75% wire-size reduction on all text assets from gzip alone; return-visit TTFB approaches zero once cached.
- **Risk:** low. `.htaccess` errors show up immediately in Apache logs; rollback is delete-the-file. I'd stage compression + caching first, then security headers, then a report-only CSP.

**B2. No `Cache-Control` policy for HTML vs. assets.** HTML must revalidate every visit (content can change); fingerprinted CSS/JS/images can be cached one year. Nothing today distinguishes them.

**B3. No Subresource Integrity for external assets.** Not applicable — audit shows zero external `<script src>` or `<link href>` to CDNs. Everything self-hosted. Nothing to do here.

### Category C — Text-asset minification (medium impact, adds toolchain)

**C1. HTML/CSS/JS all unminified.** After gzip, minification adds another 10–20% savings but not more. Real value: cleaner LCP + fewer bytes on mobile 3G.

- **Fix option 1 — small Node build:** `html-minifier-terser` + `clean-css-cli` + `terser`, wrapped in an npm script. Writes to `dist/`; deploy zip switches source dir from `required-filings/` to `dist/`. ~40 lines of `package.json` scripting. No bundler, no framework.
- **Fix option 2 — defer.** Gzip via `.htaccess` gets us most of the way. Minification is a Phase-2 improvement.

- **Savings (with minification on top of gzip):** HTML ~1.26 MB → ~180 KB over wire (was ~380 KB with gzip alone). Main CSS ~50 KB → ~42 KB. Main JS ~14 KB → ~11 KB.
- **Risk:** minifiers occasionally break edge-case CSS (attribute selectors with special chars) or JS (implicit globals). Requires a validation pass after each build.

**C2. `main.css` at 352 KB unminified is bloated with template CSS.** Phase 12.4 already identified ~409 lines of dead template rules (testimonial, team-box, pricing-section, news-box, color-palate, search-popup, preloader). Deferred pending build pipeline.
- **Fix:** run PurgeCSS as part of C1 build. Would strip most of the 409 lines automatically.
- **Savings:** ~10–15% off `main.css` before minification.
- **Risk:** PurgeCSS has known false positives with dynamic classes (menu-open, WOW.js runtime classes). Requires a manual safelist — I'd cross-reference against the classes documented in `main.js` and CLAUDE.md's "wireframe lock" list before enabling.

### Category D — External integrations still TBD (blocked on client)

**D1. Analytics IDs.** `assets/js/analytics.js` loads consent-gated GA4 + Clarity, but IDs are still `[TBD-ga4-id]` and `[TBD-clarity-id]`. No data flowing.
- **Blocker:** client needs to create GA4 property and Clarity project, share IDs.

**D2. Form auto-responder + internal notification.** Pabbly webhook is receiving submissions. What Pabbly does next (email lead, notify team, push to Google Sheets/CRM) is configured inside Pabbly's dashboard, not in code.
- **Blocker:** client-side Pabbly workflow config. Nothing to do here.

**D3. Google Business Profile → real Maps embed.** Currently using address-based `q=` fallback. Works today; upgrade to Embed API URL post-launch.
- **Blocker:** GBP creation.

### Category E — Testing gaps (verifiable but requires browser runs)

Items on the checklist that are `[ ]` because they need a live browser session, not code changes:
- Lighthouse scores (Perf ≥ 90, A11y ≥ 90, SEO ≥ 90)
- Cross-browser test: Chrome, Safari, Firefox, Edge
- Mobile viewport test: 360, 414, 768, 1024
- End-to-end form submission (Pabbly delivery confirmation)
- `tel:` / `mailto:` on real mobile device

These should run **after** Category A + B are shipped, on the production URL. Running them now measures the unoptimized site.

### Category F — Non-issues verified (worth documenting)

- **HTML validation:** clean (`html-validate` passes 0 errors, 0 warnings)
- **Broken links:** clean (Phase 11 sweep)
- **Duplicate IDs:** clean (Phase 1.2 fixed)
- **Alt text:** clean (Phase 10.3 verified)
- **Mixed content:** none (all assets relative, no `http://`)
- **Deploy zip already excludes:** `scss/`, `audit.sh`, `.nojekyll`, `*.map` — good
- **Source maps in production:** not shipped (already excluded)

---

## Proposed action plan

Ordered by ROI. Each phase is independently shippable and independently reversible. **Nothing runs until you approve the phases you want.**

### Phase P — Prep (30 min, no code)
- [ ] Tag current state: `git tag pre-prod-hardening`
- [ ] Take one baseline metric per key page (index, contact, a service page) so before/after is honest. Chrome DevTools Performance panel screenshots — cold cache, mobile 4G throttling. Save under `perf-baseline/`.

### Phase 1 — Asset diet (2–3 hours, execute in one commit) — **you selected this**
Concrete deliverables:
- [ ] Run SVGO on `favicon.svg`, `black-logo.svg`, `white-logo.svg`. Diff visually. If regression → fall back to PNG at real dimensions.
- [ ] Delete duplicate SVG copies in `assets/img/logo/` (the `[11] Required Filings…svg` files).
- [ ] Delete `dark-mode.css` and empty `color.css`; grep-verify no `<link>` references remain.
- [ ] Strip `@font-face` blocks for `fa-light`, `fa-thin`, `fa-duotone` from `all.min.css`. Delete those `.woff2` files from `assets/webfonts/`.
- [ ] Delete all `.ttf` files from `assets/webfonts/` (browsers use `.woff2`, `.ttf` is dead weight in shipping).
- [ ] Update `build-deploy-zip.ps1` `robocopy /XD` list: add `home-2`, `home-3`, `home-4`, `home-5`.
- [ ] Rebuild the deploy zip and report before/after size.

**Expected result:** deploy zip drops from ~15 MB to ~5–6 MB. Cold-cache first-visit weight drops ~2 MB.

### Phase 2 — Server config (1 hour, single new file) — **not currently selected; strongly recommend adding**
- [ ] Author `.htaccess` at `required-filings/` root with:
  - Gzip (via `mod_deflate`) for HTML/CSS/JS/SVG/JSON/XML
  - Brotli block (via `mod_brotli`) — commented out; enable only if cPanel exposes it
  - `Cache-Control: public, max-age=31536000, immutable` for `.woff2`, images, and versioned CSS/JS
  - `Cache-Control: no-cache, must-revalidate` for `.html`
  - HTTPS enforcement via `mod_rewrite`
  - `Strict-Transport-Security: max-age=31536000; includeSubDomains`
  - `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy` (minimal), `X-Frame-Options: SAMEORIGIN`
  - `ErrorDocument 404 /404.html`
- [ ] Add report-only CSP (`Content-Security-Policy-Report-Only`) — observation mode for 2 weeks before enforcing.

**Expected result:** ~65–75% wire-size reduction on text assets; return-visit near-instant; free security posture upgrade.

**Verification (post-deploy):** `curl -I https://requiredfilings.com/assets/css/main.css` should show `Content-Encoding: gzip` and `Cache-Control: max-age=31536000`. `curl -I https://requiredfilings.com/` should show HSTS and security headers.

### Phase 3 — Minification build (2–3 hours, adds toolchain) — **you selected this**
- [ ] Add `html-minifier-terser`, `clean-css-cli`, `terser`, `svgo`, `cpx` to `devDependencies`.
- [ ] Add npm scripts: `build` (mirror + minify → `dist/`), `build:preview` (serve `dist/` locally on port 8080), `build:validate` (run `html-validate` against `dist/`).
- [ ] Update `build-deploy-zip.ps1` to package `dist/` instead of `required-filings/`. Keep the option to package raw source with a `-Raw` flag for rollback.
- [ ] Document `README.md` build/deploy workflow.

**Expected result:** deploy zip drops from ~5–6 MB (post-Phase-1) to ~4 MB. Over-wire HTML shrinks additional ~20% on top of gzip.

### Phase 4 — Verification & sign-off (1 hour, browser required)
- [ ] Lighthouse against production URL: Performance, A11y, Best Practices, SEO. Record scores per page.
- [ ] `curl -I` audit: confirm compression, caching, and security headers active.
- [ ] Cross-browser smoke: Chrome, Safari, Firefox, Edge — homepage + contact + one service page.
- [ ] Mobile viewport test at 360/414/768.
- [ ] Update `production-checklist.md` — tick the items now provably done, keep the browser-required items honest.
- [ ] Run `sync-progress.ps1` to update the CLAUDE.md snapshot.

---

## What I am NOT touching (respecting the constraints)

Per CLAUDE.md wireframe lock and content freeze:
- No section adds/removes/reorders.
- No copy edits.
- No colour, typography, or spacing changes.
- No animation timing changes (Phase 11 already tightened this).
- No new visible UI (banners, badges, notices).
- No framework migration.

If any minification or purge step would risk a visible regression, I'll stop and flag it instead of pushing through.

---

## Appendix A — Font Awesome icons in use (24 unique names)

Fully substitutable with a 24-icon SVG sprite (~8 KB) if we ever decide to drop FA entirely.

```
fa-arrow-right       fa-arrow-up          fa-arrow-up-right
fa-bars              fa-building          fa-calendar
fa-calendar-check    fa-check             fa-chevron-down
fa-chevron-right     fa-circle-check      fa-clipboard-check
fa-clock             fa-clock-two-thirty  fa-envelope
fa-heart             fa-location-dot      fa-map-marker-alt
fa-phone             fa-shield            fa-star
fa-times             fa-user-group        fa-whatsapp
```

Weight distribution: `fa-solid` ×497, `fa-regular` ×41, `fa-sharp` ×1, `fa-brands` ×1 (implicit via `fa-whatsapp`).

## Appendix B — Deliverables you'll get after execution

Assuming Phases 1 + 3 (your selection) plus Phase 2 (recommended add-on):

1. **Optimised assets** committed in-place under `required-filings/`.
2. **`.htaccess`** at `required-filings/` root (only if Phase 2 approved).
3. **`dist/` build output** from `npm run build` (Phase 3).
4. **Updated `build-deploy-zip.ps1`** with expanded excludes and dist-vs-source flag.
5. **`perf-baseline/` folder** with before/after evidence.
6. **This file (`production-audit.md`)** updated with actual measurements post-implementation.
7. **`production-checklist.md`** updated with newly-completed items.

## Appendix C — Blockers requiring client input (cannot be fixed in code)

| Item | Blocker | Who |
|---|---|---|
| GA4 real ID | Google account + property creation | Client |
| Clarity real ID | Microsoft account + project creation | Client |
| Pabbly auto-responder | Pabbly workflow config in their dashboard | Client |
| Pabbly internal notification email | Pabbly workflow config | Client |
| Google Business Profile + Maps Embed API key | GBP verification | Client |
| Domain DNS pointing to cPanel host | Registrar action | Client |
| SSL cert (usually AutoSSL on cPanel) | cPanel provisioning | Client / Host |

---

---

# Actual results (executed 2026-07-18)

## Phase P — Prep
- Git tag `pre-prod-hardening` created. Rollback: `git reset --hard pre-prod-hardening`.
- SVG backups saved to `_svg_backup/` at repo root (not shipped).

## Phase 1 — Asset diet

**A1/A2. SVGs rasterised.** `extract-svg-raster.py` extracted the embedded base64 PNG from each SVG and re-encoded at real render dimensions.

| File | Before | After (PNG) | After (WebP) | Saving |
|---|---:|---:|---:|---:|
| `favicon.svg` → `favicon.png/.webp` | 373,423 | 26,387 | 6,198 | 93% / 98% |
| `black-logo.svg` → `black-logo.png/.webp` | 182,043 | 17,396 | 4,508 | 90% / 97% |
| `white-logo.svg` → `white-logo.png/.webp` | 283,056 | 17,311 | 4,522 | 94% / 98% |
| **Total** | **838,522** | **61,094** (PNG) | **15,228** (WebP) | **93%** |

Duplicate `[11] Required Filings…svg` files deleted. HTML swapped from `.svg` → `.png` in 63 references across all 20 pages (`swap-logo-svg-to-png.ps1`). `favicon.svg` deleted (was not referenced by any HTML).

**A3. Font Awesome trimmed.** `trim-fontawesome.py` results:

| Change | Bytes freed |
|---|---:|
| Deleted all `.ttf` files (7 fonts, never fetched — browsers use woff2) | 5,102,060 |
| Deleted unused `.woff2` (fa-light, fa-thin, fa-duotone, fa-v4compatibility) | 1,225,520 |
| Stripped 5 `@font-face` blocks + `.ttf` fallback declarations from `all.min.css` | 1,939 |
| **Total** | **6,329,519 (~6.0 MB)** |

Remaining webfonts: fa-solid-900 (297 KB), fa-regular-400 (349 KB), fa-brands-400 (102 KB). Only weights the site actually uses.

**A4. Deploy exclusions expanded.** `build-deploy-zip.ps1` now excludes:
- Directories: `scss`, `.gstack`, `home-2`, `home-3`, `home-4`, `home-5`, `header`
- Files: `audit.sh`, `.nojekyll`, `*.map`, `favicon-2.svg` through `favicon-5.svg`

**A5. Dead CSS deleted.** `dark-mode.css` (39 KB) + `color.css` (0 B) + `rtl.css` (76 B) — all unlinked; deleted from `assets/css/`.

## Phase 2 — Server config

**B1. `.htaccess` written** at `required-filings/.htaccess` (8.5 KB). Contains:
- HTTPS enforcement + strip `/index.html` → `/` (301)
- `mod_deflate` (gzip) for HTML/CSS/JS/SVG/JSON/XML — skips pre-compressed formats
- `mod_brotli` block ready (activates automatically if the cPanel host supports it)
- `mod_expires` + `Cache-Control` — HTML revalidates; CSS/JS/images/fonts get 1yr immutable
- Security headers: `Strict-Transport-Security` (1yr, includeSubDomains), `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Permissions-Policy`, `Cross-Origin-Opener-Policy`, `Cross-Origin-Resource-Policy`
- CORS `Access-Control-Allow-Origin: *` for `.woff2` (needed by preload with `crossorigin` attr)
- CSP **in report-only mode** (Content-Security-Policy-Report-Only) — allows Pabbly, GA4, Clarity, Google Maps; flip to enforcing after 2 weeks of clean reports
- `ErrorDocument 404 /404.html`
- Blocks `.git`, `.env`, `package*.json`, `*.md` from HTTP access; disables directory listing; disables `ServerSignature` and ETags

## Phase 3 — Minification build

Added `scripts/build.mjs` (Node ESM, uses html-minifier-terser + clean-css + terser + svgo). Reads `required-filings/`, writes `dist/`, preserves filenames.

Configured to match the source's html-validate profile: keeps uppercase `<!DOCTYPE html>`, keeps explicit `type="text"` on inputs, keeps entity references. Result: dist HTML validates identically to source (no minification-introduced regressions).

**Measured savings (single `npm run build:clean` run):**

| Type | Files | Before | After | Saved |
|---|---:|---:|---:|---:|
| HTML | 20 | 1,258,289 | 627,853 | **50.1%** |
| CSS | 5 | 371,168 | 297,623 | 19.8% |
| JS | 11 | 93,707 | 44,761 | **52.2%** |
| SVG | 21 | 65,358 | 43,537 | 33.4% |
| Binary + already-min (copied) | 116 | 4,037,997 | 4,037,997 | 0% |

Elapsed: 1.7s. Only 5 CSS + 11 JS files were minified; `*.min.css` / `*.min.js` files (bootstrap, all.min.css, swiper, gsap, jquery, etc.) were copied unchanged since re-minifying already-min output rarely helps and risks regressions.

## Deploy zip results

Measured against the actual pre-hardening zip built earlier tonight (`requiredfilings-deploy-20260718-1937.zip`, before any of this pass ran):

| Zip mode | Size | Change |
|---|---:|---:|
| Pre-hardening zip (baseline) | **7.67 MB** | — |
| **Minified dist zip (new default)** | **3.06 MB** | **−60%** |
| Raw source zip (`-Raw` flag, for debugging) | 3.12 MB | −59% |

Zip DEFLATE compresses aggressively, so the visible delta between minified/raw source is only 60 KB. The **real** minification win shows up over-the-wire when combined with server gzip: browsers get 50% smaller HTML on top of gzip's compression.

Uncompressed on-disk site total:
- `required-filings/` (source): 8.2 MB
- `dist/` (build output): 5.2 MB

## Pre-existing source issues (not introduced by hardening — noted for future work)

`html-validate --config .htmlvalidate.json required-filings/**/*.html` reveals 8 problems (7 errors, 1 warning) that were **already** in the source when I started. Build.md Phase 18.4's "0 errors, 0 warnings" claim has drifted.

Errors:
- `no-implicit-button-type` + `text-content` on index.html back-to-top button — **FIXED** during this pass (`fix-back-to-top-a11y.ps1` added `type="button"` + `aria-label="Back to top"`; 19 other pages already had it).
- 6× `tel-non-breaking` — phone numbers use U+00A0 non-breaking space character instead of `&nbsp;` entity. Renders identically in browsers. Cosmetic policy warning, no user-facing impact.
- 1 warning: `heading-level` — a marquee/carousel starts with `<h4>` before `<h1>` on `index.html`. Real but low-impact.

None of these come from the minifier. They are all present in `required-filings/*.html`.

## Additional artefacts introduced

Repo-root files added by this pass:
- `production-audit.md` (this file)
- `extract-svg-raster.py` (one-shot SVG raster extraction)
- `swap-logo-svg-to-png.ps1` (one-shot HTML link swap)
- `trim-fontawesome.py` (one-shot FA cleanup)
- `fix-back-to-top-a11y.ps1` (one-shot a11y fix)
- `scripts/build.mjs` (production build — permanent)
- `scripts/preview.mjs` (dev preview server — permanent)
- `_svg_backup/*.svg` (safety backup — not shipped)
- `package.json` gained scripts: `build`, `build:clean`, `validate`, `validate:dist`, `preview`, `deploy:zip`
- `dist/` (build output — gitignore candidate)
- `requiredfilings-deploy-*.zip` at repo root (build output — gitignore candidate)

Files removed from `required-filings/`:
- `assets/img/favicon.svg` (unreferenced, 373 KB)
- `assets/img/logo/black-logo.svg` (replaced by PNG/WebP)
- `assets/img/logo/white-logo.svg` (replaced by PNG/WebP)
- `assets/img/logo/[11] Required Filings…svg` × 3 (duplicates)
- `assets/css/dark-mode.css`, `color.css`, `rtl.css` (unlinked)
- `assets/webfonts/*.ttf` × 7 (never fetched — browsers use woff2)
- `assets/webfonts/fa-light-300.woff2`, `fa-thin-100.woff2`, `fa-duotone-900.woff2`, `fa-v4compatibility.woff2` (unused)

`.gitignore` update recommended (see "Next steps" below).

## What still requires client input (unchanged from findings above)

| Item | Blocker |
|---|---|
| GA4 real ID (currently `[TBD-ga4-id]` in `analytics.js`) | Client to create GA4 property |
| Clarity real ID (currently `[TBD-clarity-id]`) | Client to create Clarity project |
| Pabbly auto-responder + internal-notify email | Pabbly workflow config |
| Google Business Profile → real Maps Embed API URL | GBP verification |
| Domain DNS + SSL cert | cPanel/registrar action |

## What still requires browser testing (unchanged)

Cannot be verified from a Node build:
- Lighthouse Performance/A11y/SEO scores on production URL
- Cross-browser: Chrome, Safari, Firefox, Edge
- Mobile viewport at 360/414/768
- Live form → Pabbly delivery confirmation
- `tel:` / `mailto:` on real mobile device

Run these against the **live production URL** after cPanel deploy — running now measures the pre-optimised state.

## Next steps

1. **Verify the deploy zip** locally: unzip to a test folder, run `npm run preview`, check pages render at http://localhost:8080.
2. **Add to `.gitignore`:** `dist/`, `_svg_backup/`, `requiredfilings-deploy-*.zip`, `node_modules/`.
3. **Upload the zip to cPanel** per the on-screen instructions from `build-deploy-zip.ps1`.
4. **Post-deploy sanity check** (from your shell):
   ```
   curl -I https://requiredfilings.com/assets/css/main.css
   #  -> Content-Encoding: gzip
   #  -> Cache-Control: public, max-age=31536000, immutable
   curl -I https://requiredfilings.com/
   #  -> Strict-Transport-Security: max-age=31536000; includeSubDomains
   #  -> X-Content-Type-Options: nosniff
   #  -> Cache-Control: public, max-age=0, must-revalidate
   ```
5. **Run Lighthouse** against `https://requiredfilings.com/`, `/contact.html`, `/gst-services.html`. Save scores.
6. **After 2 weeks of clean CSP-Report-Only:** flip `Content-Security-Policy-Report-Only` → `Content-Security-Policy` in `.htaccess`.
7. **When client supplies GA4 + Clarity IDs:** replace tokens in `required-filings/assets/js/analytics.js`, rebuild, redeploy.

## Rollback

- Undo file changes: `git reset --hard pre-prod-hardening`
- Undo `dist/` build: `rm -rf dist/`
- Undo minification devDeps: `git checkout pre-prod-hardening -- package.json package-lock.json && npm install`
- Re-generate raw source zip: `npm run deploy:zip -- -Raw`
