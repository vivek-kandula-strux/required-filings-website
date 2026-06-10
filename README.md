# RequiredFilings.com

Production website for **RequiredFilings.com**, a compliance and filing services company in India: company registration, statutory filings, GST, tax, ROC compliance, IPR, ISO certification, MSME/ZED, and accounting.

**Live deploy:** https://vivek-kandula-strux.github.io/required-filings-website/
*(URL active after the first successful run of the **Deploy GitHub Pages** workflow.)*

## Repo layout

| Path | What it is |
|---|---|
| [required-filings/](required-filings/) | The deployed site — 19 flat HTML pages + `assets/` (CSS, JS, img, fonts, scss). This folder is the Pages publish root. |
| [buyer-file/](buyer-file/) | Original Brevon template + content principles + sitemap reference. Not deployed. |
| [documentation/](documentation/) | Project documentation. Not deployed. |
| [CLAUDE.md](CLAUDE.md) | Project context, wireframe lock, UTF-8 rule, `[TBD-*]` blocker catalog. Read this first if you are picking up the work. |
| [production-checklist.md](production-checklist.md) | Source of truth for launch readiness. Tick `- [ ]` to `- [x]`, run `sync-progress.ps1`. |
| `*.ps1` | Helper scripts for bulk HTML edits (mojibake repair, alt-text upgrade, form hardening, legal-page generation, progress sync). |

## Deployment

Deploys via the **`Deploy GitHub Pages`** GitHub Actions workflow at [.github/workflows/deploy-pages.yml](.github/workflows/deploy-pages.yml). The workflow:

1. Triggers on every push to `main` that touches `required-filings/**` or the workflow itself
2. Uploads `required-filings/` as the Pages artifact
3. Deploys via `actions/deploy-pages@v4`

The publish root contains a `.nojekyll` file so GitHub Pages skips Jekyll processing.

### Enable Pages (one-time, per repo)

In **Settings → Pages**, set **Source** to **GitHub Actions**. The first push then auto-deploys.

### Manual trigger

Push to `main` is enough. To force a redeploy without a code change, run the workflow from the **Actions** tab via `workflow_dispatch`.

## What ships today

- 15 production pages (home, about, contact, services, blog, and 10 service pages)
- 4 legal pages (privacy, terms, refund, disclaimer)
- All contact forms have `name`/label/validation/honeypot/success-error containers wired
- All `<img>` tags have contextual or `aria-hidden` decorative alt text
- All page titles and meta descriptions are unique
- Wireframe is locked — see CLAUDE.md

## What is still TBD before public launch

These items need owner-supplied data, not code. Search the codebase for the bracketed token to find every place that needs the value plugged in. Full list in [CLAUDE.md](CLAUDE.md) under "P0 blockers needing real business data".

| Token | Replace with |
|---|---|
| `[TBD-phone]`, `[TBD: +91 phone]` | Real Indian phone for `tel:` links + visible labels |
| `[TBD-email]`, `[TBD: hello@requiredfilings.com]` | Real contact email for `mailto:` links + visible labels |
| `[TBD: office address]`, `[TBD: registered office address]`, `[TBD: city of registered office]` | Real Indian street address + city |
| `[TBD: legal entity name]` | Operating company name (terms.html, disclaimer.html) |
| `GSTIN: [TBD]`, `CIN/Firm reg: [TBD]` | Real GSTIN + CIN |
| `[TBD-form-endpoint]` | Real contact-form backend URL (Formspree, Web3Forms, Netlify Forms, or custom) |
| `[TBD-newsletter-endpoint]` | Real newsletter signup URL |
| `[TBD-map-embed]` | Google Maps embed URL on `contact.html` |
| `[TBD: date]`, `[TBD: founder name]`, `[TBD: year founded]`, `[TBD]` (counters), testimonial placeholders | Real dates, names, numbers, testimonials |

After plugging in any of these, tick the matching item in [production-checklist.md](production-checklist.md) and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\sync-progress.ps1
```

## Local development

No build step. Open any page in `required-filings/` directly in a browser, or serve the folder with any static server.

```powershell
# from repo root
cd required-filings
python -m http.server 8000
# then open http://localhost:8000
```

## Progress

See [production-checklist.md](production-checklist.md). Snapshot mirrored in [CLAUDE.md](CLAUDE.md).
