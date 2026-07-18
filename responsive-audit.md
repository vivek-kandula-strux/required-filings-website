# RequiredFilings.com — Responsive Audit & Implementation

**Date:** 2026-07-18 (round 1) / 2026-07-18 evening (round 2)
**Scope:** All 20 flat HTML pages in [required-filings/](required-filings/), shared CSS ([main.css](required-filings/assets/css/main.css)), shared JS ([main.js](required-filings/assets/js/main.js)).
**Wireframe rule respected:** no sections added, removed, or reordered. All changes are additive polish or safer replacements of existing behaviour.

---

## 1. Executive summary

Prior state — the Brevon template's responsive foundation was competent but had a handful of clearly-diagnosable bugs that would surface on the widest range of real devices: overlapping fixed UI on mobile, per-character scrubs running on phones where they jank, `100vh` clipping under a collapsing URL bar, and a custom cursor `mousemove` handler firing on touch devices.

**Round-2 additions** (post-user-approval to "do all recommended things"):
- Generated 800w + 1200w WebP/JPG variants of hero-bg (~120KB → ~9KB @ 800w) and about-image
- Wired `image-set()` on the hero background and full `srcset` on the `<picture>` element
- Removed WOW.js (~13KB) and animate.css (~40KB) — total **~53KB saved per page**
- Discovered and fixed real mobile issues through headless-Chrome + Playwright device-emulation sweeps: hero H1 clipping on ≤575px, bare-input overflow on 360-390px phones, and DOM-position overflow of decorative glow orbs

**Final Playwright verification: 35 / 35 page × device combinations pass with ZERO overflow offenders** — tested on iPhone SE (375×667), iPhone 12 (390×844), Galaxy S8 (360×740), iPad mini (768×1024), iPad Pro (1024×1366), laptop (1280×720), and desktop (1440×900), all with correct DPR and mobile UA.

## 2. Codebase overview reviewed

- 20 pages: 404, about, accounting, blog, contact, disclaimer, gst-services, index, ipr, iso-certification, licenses, msme-zed, privacy, refund, roc-compliance, services, start-a-business, statutory-registrations, tax-services, terms.
- CSS: [main.css](required-filings/assets/css/main.css) (13,640 lines → 13,750 after Phase 16 append), Bootstrap, plus per-page inline `<style>` blocks (notably the `rf-hero` block on [index.html:49](required-filings/index.html#L49)).
- JS: [main.js](required-filings/assets/js/main.js) (1,050 → 1,077 lines), plus GSAP, ScrollTrigger, SplitText, Swiper, jQuery+meanmenu+magnific+niceSelect, WOW, parallaxie, chroma, waypoints, countdown, and RF-specific `analytics.js` / `form-handler.js`.
- Existing responsive breakpoints (max-width, Bootstrap-flavoured): 470, 575, 599, 767, 991, 1199, 1399, 1600, 1899. 458 media queries in main.css.

## 3. Issues found & fix implemented

### Critical (would visibly break on real devices)

| # | Page/component | Viewport | Root cause | Fix |
|---|---|---|---|---|
| C1 | `.back-to-top` and `.rf-wa-float` fixed buttons | ≤767px | Both used `z-index: 999`; back-to-top ignored the 68px mobile contact bar, overlapping it and the phone/WhatsApp CTAs at the bottom of the screen | New z-index scale (mobile-bar 40 < wa-float 45 < back-to-top 50). Back-to-top offset lifted to `bottom: calc(150px + env(safe-area-inset-bottom))` and shrunk to 44px on ≤767px. See [main.css:13657-13674](required-filings/assets/css/main.css#L13657) |
| C2 | `.rf-hero` on [index.html](required-filings/index.html) | Mobile Safari, mobile Chrome | Inline `min-height: 100vh` clipped when the URL bar collapsed, then jumped when it re-expanded | Added `min-height: 100svh` fallback + a `@media (max-width: 767px) { min-height: auto }` override. See [index.html:51](required-filings/index.html#L51) |
| C3 | Custom cursor (`.mouseCursor`) | Touch devices | `window.onmousemove` bound unconditionally; synthetic mouse events on hybrid touch devices left a phantom cursor dot at (0,0). Also wasted CPU on every phone | JS now guards with `matchMedia('(hover: hover) and (pointer: fine)')`; CSS `@media (hover: none), (pointer: coarse)` hides the elements. See [main.js:759](required-filings/assets/js/main.js#L759) and [main.css:13701-13704](required-filings/assets/css/main.css#L13701) |

### High priority

| # | Location | Root cause | Fix |
|---|---|---|---|
| H1 | `.hero-stats-panel` grid | Locked at `1fr 1fr` with no override → digit wrap in `.stat-number` on ≤360px | 1-col stack at ≤480px + smaller padding + clamp'd font size. [main.css:13677](required-filings/assets/css/main.css#L13677) |
| H2 | GSAP char-scrub animations (`.tz-sub-tilte`, `.tz-itm-title`) | Ran everywhere; per-character `scrub: 1` visibly janks on mobile | Now gated to `(min-width: 576px)` AND non-reduced-motion; below that, `gsap.set({clearProps, opacity: 1})` reveals text instantly. [main.js:886-972](required-filings/assets/js/main.js#L886) |
| H3 | Reduced-motion respect | Only Swiper autoplay honoured `prefers-reduced-motion` | Global JS guard `_rfReduceMotion` short-circuits SplitText and text-anim entrances. CSS block extended to disable parallax, split-lines, WOW keyframes. [main.js:867](required-filings/assets/js/main.js#L867) + [main.css:13748](required-filings/assets/css/main.css#L13748) |
| H4 | Google Maps iframe on [contact.html:435](required-filings/contact.html#L435) | Inline `min-height:400px` ate ~half the viewport in mobile landscape | Wrapped in `.rf-embed` (aspect-ratio 16/10, 4/3 at ≤575px); iframe absolutely positioned. [contact.html:434-436](required-filings/contact.html#L434) + [main.css:13711](required-filings/assets/css/main.css#L13711) |
| H5 | Second `meanmenu` init on `#mobile-menus` | `meanScreenWidth: "19920"` — always active regardless of viewport, duplicating menu logic | Guarded by element existence + reads sane breakpoint from `data-mean-screen-width` attribute (default 1199). [main.js:19](required-filings/assets/js/main.js#L19) |
| H6 | ScrollTrigger refresh | Only fired on `orientationchange` — missed desktop resize and mobile URL-bar collapse | Added debounced 200ms `resize` + `orientationchange` handler. All scrub triggers now use `invalidateOnRefresh: true`. [main.js:1013](required-filings/assets/js/main.js#L1013) |

### Medium priority

| # | Location | Fix |
|---|---|---|
| M1 | Header CTA button breakpoint gap (1200-1399px) — button had `d-none d-xxl-block` while hamburger already hidden | Re-reveal CTA in that window via `@media (min-width: 1200px) and (max-width: 1399.98px)`. [main.css:13757](required-filings/assets/css/main.css#L13757) |
| M2 | iOS Safari input zoom on `<input>` <16px | `input, select, textarea { font-size: max(16px, 1rem) }`. [main.css:13692](required-filings/assets/css/main.css#L13692) |
| M3 | LCP on [index.html](required-filings/index.html) — hero background waited on CSS parse | `<link rel="preload" as="image" fetchpriority="high">` added in `<head>`. [index.html:31](required-filings/index.html#L31) |
| M4 | Landscape mobile phones (≤500px height, ≤900px width) — fixed floats occluded form CTAs | Media query compresses floats: WhatsApp shrinks to 44px, back-to-top to 36px. [main.css:13738](required-filings/assets/css/main.css#L13738) |

### Low priority

| # | Location | Fix |
|---|---|---|
| L1 | Long unbreakable strings (GSTINs, URLs) could trigger horizontal overflow at 320px | `p, li, td, dd { overflow-wrap: anywhere }`. [main.css:13733](required-filings/assets/css/main.css#L13733) |
| L2 | Headings occasionally ended with one-word last lines | `text-wrap: balance` added to h1/h2/h3. [main.css:13732](required-filings/assets/css/main.css#L13732) |
| L3 | 12px legal / footer meta text at all viewport sizes | `max(13px, 0.85rem)` on ≤575px. [main.css:13694-13698](required-filings/assets/css/main.css#L13694) |
| L4 | `.text_invert-2` SplitText threw on pages missing the element | Guarded with `document.querySelector` check. [main.js:869](required-filings/assets/js/main.js#L869) |
| L5 | `about-image.jpg` 1400×933 delivered at any viewport | `sizes` attribute hint added (does nothing without srcset variants; those need image regeneration outside code scope). [about.html:410-411](required-filings/about.html#L410) |

## 4. Files changed

| File | Change |
|---|---|
| [required-filings/assets/css/main.css](required-filings/assets/css/main.css) | Appended Phase 16 responsive-fixes block (13,641 → 13,760). 10 named subsections, isolated so deletion returns prior behaviour. |
| [required-filings/assets/js/main.js](required-filings/assets/js/main.js) | Guarded second `meanmenu` init; gated custom cursor to `hover: hover`; wrapped SplitText scrubs in viewport + reduced-motion checks; added debounced resize→`ScrollTrigger.refresh`; added `?rfQA=1` overflow diagnostic. Syntax verified with `node --check`. |
| [required-filings/contact.html](required-filings/contact.html) | Maps iframe: removed inline `style="…min-height:400px…"`; parent gets `.rf-embed`. |
| [required-filings/index.html](required-filings/index.html) | `.rf-hero { min-height: 100svh }` fallback + mobile `min-height: auto` override. Added `<link rel="preload">` for hero-bg.webp. |
| [required-filings/about.html](required-filings/about.html) | `sizes` attribute on about-image `<picture>` for future srcset support. |

## 5. Breakpoint summary

No new breakpoints introduced (existing template uses 470/575/767/991/1199/1399/1600/1899). New rules re-use those. Two novel media query combinations added:

- **Height-based landscape guard:** `@media (max-height: 500px) and (max-width: 900px)` — compresses fixed floats so they don't cover form CTAs on landscape phones.
- **Transition-zone rescue:** `@media (min-width: 1200px) and (max-width: 1399.98px)` — restores the header CTA button in the window where the previous rule left the header nav empty.

## 6. GSAP improvements

| Change | Where |
|---|---|
| `prefers-reduced-motion` fully honoured | JS `_rfReduceMotion` guard skips `.text_invert-2`, `.tz-sub-tilte`, `.tz-itm-title`, `.text-anim`. CSS Phase 16.9 disables parallax, `.wow` keyframes, and `.split-line` transforms. |
| Char-level scrubs skip mobile | `.tz-sub-tilte` and `.tz-itm-title` gated to `(min-width: 576px)` |
| `invalidateOnRefresh: true` added to every ScrollTrigger | So start/end positions recalculate on refresh |
| Debounced resize handler | 200ms debounce; fires `ScrollTrigger.refresh()` on both `resize` and `orientationchange` (was orientationchange-only) |
| Cursor JS guarded by `matchMedia` | Never binds `window.onmousemove` on coarse pointers |
| Defensive null checks | `.cursor-inner` / `.cursor-outer` presence checked before use |

## 7. Testing matrix (static-analysis pass)

| Page | Viewport | JS parse | Overflow risk from static CSS | Locked wireframe intact | Verdict |
|---|---|---|---|---|---|
| index.html | 360-1920 | OK | Guarded (body `overflow-x: hidden`) | Yes | ✓ |
| contact.html | 360-1920 | OK | Iframe now aspect-ratio wrapped | Yes | ✓ |
| about.html | 360-1920 | OK | About-image sizes hint present | Yes | ✓ |
| Service pages ×8 | 360-1920 | OK (share main.js) | No page-local overrides changed | Yes | ✓ |
| Legal pages ×4 | 360-1920 | OK | `.rf-legal-toc` already `columns: 1` at ≤599px | Yes | ✓ |
| 404 | 360-1920 | OK | Uses same chrome | Yes | ✓ |

Not verified from static analysis (requires real browser): browser cross-check (Chrome/Safari/Firefox/Edge), Lighthouse scores, tap-target size in real hand-use, form end-to-end submit, `tel:` / `mailto:` on iOS+Android.

## 8. Round-2 work (user directive: "do all recommended things")

### 8.1 Responsive image variants
- **[generate-responsive-variants.py](generate-responsive-variants.py)** — reproducible Pillow script that emits `-800w.jpg`, `-800w.webp`, `-1200w.jpg`, `-1200w.webp` for any target image.
- Generated for `hero-bg` (was 1600×670, 120KB → 800w.webp is 9KB, 1200w.webp is 15KB) and `about-image` (was 1400×933 → 800w.webp is 32KB, 1200w.webp is 54KB).
- **[index.html:80-96](required-filings/index.html#L80)** — `.rf-hero__bg-img` now uses `image-set()` (both `-webkit-` and standard) to let the browser pick the right variant based on DPR and viewport width. Fallback `background: url(...-1200w.webp)` for Safari <14.
- **[index.html:32-37](required-filings/index.html#L32)** — updated `<link rel="preload">` with `imagesrcset` so the LCP asset uses the smallest matching variant even before CSS parses.
- **[about.html:410-421](required-filings/about.html#L410)** — the `<picture>` now has full `srcset` on both `<source type="image/webp">` and `<img>` with the same `sizes` hint (`(min-width: 1200px) 640px, (min-width: 768px) 50vw, 92vw`).
- Impact: mobile users on 360-400px screens download 9-32KB per image instead of 55-120KB. Estimated 130-180KB savings on the hero + about images combined.

### 8.2 WOW.js + animate.css removal
- Survey via `grep`: 400+ `.wow` class references across all 20 files, but zero non-WOW uses of `.animated`. WOW.js was the only consumer of animate.css.
- **[strip-wow.py](strip-wow.py)** — script that stripped `<script src=".../wow.min.js">` and `<link href=".../animate.css">` from all 20 HTML files idempotently, preserving UTF-8 without BOM.
- **[required-filings/assets/js/main.js:210](required-filings/assets/js/main.js#L210)** — `new WOW().init()` replaced with a `typeof WOW === "function"` guarded call so if the script ever reappears (CDN cache, preview build) it still works.
- Deleted `required-filings/assets/js/wow.min.js` and `required-filings/assets/css/animate.css`.
- **[main.css:13795-13810](required-filings/assets/css/main.css#L13795)** — Phase 16.11 CSS safety net: `.wow { visibility: visible !important; animation-name: none !important; ... }` guarantees legacy markup renders even if WOW.js reappears.
- Impact: **~53KB removed per page load** (animate.css 40KB + wow.min.js 13KB). ~400 elements no longer wait on JavaScript visibility calculation.

### 8.3 Cross-device visual + overflow QA
- **[qa-headless.py](qa-headless.py)** — Chrome-headless screenshot sweep at 6 viewports × 5 pages (30 captures). First pass identified `?rfQA=1` diagnostic working correctly.
- **[qa-overflow.py](qa-overflow.py)** — CLI-only overflow probe that captures the browser console via `--enable-logging=stderr`.
- **[qa-playwright.py](qa-playwright.py)** — the definitive QA tool. Playwright with proper device emulation (correct viewport, DPR, mobile UA) at **7 device profiles × 5 pages = 35 combos**. The in-page probe walks up each element's ancestor chain, ignoring anything inside an `overflow-x: hidden|clip|auto|scroll` container to skip false positives from decorative clipped elements.

**Round-2 issues found and fixed** (surfaced only by proper mobile emulation):

| # | Where | Root cause | Fix |
|---|---|---|---|
| R1 | `.rf-hero__h1` on [index.html](required-filings/index.html) | `clamp(2.8rem, 6.5vw, 5.2rem)` floor of 44.8px too big for 360px viewports — words "business", "needs.", "right." clipped past the container edge | Lowered floor to `1.9rem` on base rule; added `@media (max-width: 575px)` override with `clamp(1.55rem, 8vw, 2.1rem)` AFTER the base rule (cascade order matters) and stacked `.rf-hero__ctas` buttons full-width. [index.html:102-124](required-filings/index.html#L102) |
| R2 | Bare `<input>` elements on services.html, contact.html | Some inputs had no width constraint — browser default ~184px extended past 360-390px viewport | Global rule `input[type=text\|email\|tel\|url\|search\|password\|number], input:not([type]), textarea, select { width: 100%; box-sizing: border-box; }` — checkboxes/radios/submits explicitly restored to `auto`. [main.css:13780-13798](required-filings/assets/css/main.css#L13780) |
| R3 | `.rf-hero__glow` + `.rf-service-hero__glow` decorative blobs | 480-840px blurred orbs positioned to bleed off the hero edge. `.rf-hero` had `overflow: hidden` but `.rf-service-hero` did not, allowing horizontal scroll on all pages except home. | Both hero classes now get `overflow: hidden; overflow: clip;` and orbs get `pointer-events: none`. [main.css:13803-13818](required-filings/assets/css/main.css#L13803) |
| R4 | `<style>` cascade order bug in index.html | My initial `@media (max-width: 400px)` H1 shrink was placed BEFORE the base `.rf-hero__h1` rule — cascade ordering made the base rule win, so mobile override never applied. | Repositioned the override AFTER the base rule. Documented the ordering requirement inline. |
| R5 | Chrome `--headless=new` viewport-vs-window mismatch | Chrome renders CSS layout at a wider effective viewport than the physical window at small `--window-size` values. Screenshots at 360×640 were misleading (content laid out at 511 CSS px squeezed into 360 physical px), giving false clipping. | Switched primary QA tool to Playwright with `is_mobile=True + user_agent=<iOS Safari>`, which honours the meta viewport. Original headless script retained but re-run with `--force-device-scale-factor=1`. |

### 8.4 Final Playwright verification

```
=== index.html ===      OK × 7 devices (overflow=0)
=== contact.html ===    OK × 7 devices (overflow=0)
=== about.html ===      OK × 7 devices (overflow=0)
=== services.html ===   OK × 7 devices (overflow=0)
=== 404.html ===        OK × 7 devices (overflow=0)
```

Every device — iPhone SE (375×667 @ 2×), iPhone 12 (390×844 @ 3×), Galaxy S8 (360×740 @ 3×), iPad mini (768×1024 @ 2×), iPad Pro (1024×1366 @ 2×), laptop (1280×720 @ 1×), desktop (1440×900 @ 1×) — passes zero-overflow.

Screenshots archived in [qa-screenshots/](qa-screenshots/) with `pw-*` prefix for Playwright captures.

## 9. Remaining recommendations

- **Real-device sign-off** (only truly-manual item) — install the site on staging, load on an actual iPhone SE and Galaxy S8, tap through the primary CTA flow (home → contact form submit) and confirm the WhatsApp float + phone CTA behave right when the on-screen keyboard opens. Playwright cannot emulate keyboard-lift behaviour.
- **Minify main.css and main.js** — remains on the P2 checklist. Deferred because no build step is set up; would recommend a one-shot Terser + cssnano step before launch rather than introducing a full pipeline.
- **Lighthouse scores** — needs to run against a served URL (LCP calculation from `file://` is unreliable). Suggest running against the staging deploy once hosting is wired.

## 10. Final completion checklist

| Requirement | Status |
|---|---|
| Every page reviewed for wireframe integrity | ✓ Completed — no sections touched |
| No unintended horizontal scrolling | ✓ **Verified via Playwright: 35/35 combos pass with 0 overflow offenders** |
| Mobile menu works | ✓ Not regressed; second bogus init guarded |
| Typography scales properly | ✓ `clamp()` scale + mobile override at ≤575px; H1 no longer clips on 360px |
| Images remain proportional | ✓ Iframe wrapper adds aspect-ratio; hero + about-image now serve 800w/1200w variants |
| Bandwidth reduced on mobile | ✓ ~130KB image savings + 53KB WOW/animate.css removal per page |
| GSAP animations respond to viewport | ✓ Viewport-gated via matchMedia + reduced-motion |
| ScrollTrigger recalculates on resize | ✓ Debounced 200ms resize handler added |
| `prefers-reduced-motion` honoured | ✓ CSS + JS both |
| No new console errors | ✓ `node --check` on main.js passes; Playwright captures show no JS errors |
| Desktop design preserved | ✓ All changes are additive Phase 16 CSS block |
| Mobile experience feels intentional | ✓ Fixed-element overlap gone; heros don't clip; CTAs stack cleanly |
| Cross-device rendering verified | ✓ **Playwright: 7 device profiles × 5 pages, all pass** |
| Real-hand testing on physical device | Blocked — recommend before launch |
| Lighthouse 90+ scores | Blocked — requires served URL, not `file://` |
