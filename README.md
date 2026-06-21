# kindred-marketing

Marketing landing site for [Kindred](https://kindredhome.app) — a household management app for iOS and Android.

**Stack:** Astro 4 + TypeScript · GitHub Pages (auto-deploy on push to `main`) · Google Fonts (Fraunces + Inter)
**Design:** V2 "Modern Cozy" token set, translated to CSS custom properties from the app's Flutter token files.

---

## Local development

```bash
# Install dependencies
npm install

# Start dev server (http://localhost:4321)
npm run dev

# Build for production (output in ./dist/)
npm run build

# Preview production build locally
npm run preview
```

Node 18+ required. Tested on Node 22.

---

## Project structure

```
kindred-marketing/
├── public/
│   ├── images/            # App screenshots + OG card (see images/README.txt)
│   ├── favicon.svg        # Placeholder — replace with real icon
│   ├── favicon-*.png      # TODO — see images/README.txt
│   ├── apple-touch-icon.png
│   ├── site.webmanifest
│   └── robots.txt
├── src/
│   ├── components/
│   │   ├── Hero.astro
│   │   ├── Features.astro
│   │   ├── Pricing.astro
│   │   ├── ScreenGallery.astro
│   │   ├── FAQ.astro
│   │   └── Footer.astro
│   ├── layouts/
│   │   └── Base.astro     # HTML shell + all <head> meta
│   ├── pages/
│   │   ├── index.astro    # Landing page (single scroll, ~5 viewports)
│   │   ├── privacy.astro  # /privacy — renders src/legal/privacy.md
│   │   ├── terms.astro    # /terms   — renders src/legal/terms.md
│   │   └── 404.astro
│   └── styles/
│       ├── tokens.css     # V2 design tokens → CSS custom properties
│       └── global.css     # Reset + typography + layout utilities
├── astro.config.mjs
├── package.json
└── tsconfig.json
```

---

## Deploy

**This repo is the single source of truth AND the host.** Push to `main` →
GitHub Actions (`.github/workflows/deploy.yml`) builds the Astro site → deploys
to GitHub Pages → live at https://kindredhome.app in ~2 minutes. The apex is
owned by the tracked `public/CNAME` (`kindredhome.app`), re-asserted on every
deploy. See **`DEPLOY.md`** for the full process, the CI guards
(`assetlinks.json` + `CNAME`), and the Android App Links / Play deep-link setup
(**`DEEPLINKS.md`**).

---

## Pre-launch checklist

Tick these before DNS cutover:

- [ ] Real app screenshots added to `public/images/` (see `public/images/README.txt`)
- [ ] Official App Store badge SVG replaced (update `src/components/Hero.astro` + real URL)
- [ ] Official Google Play badge SVG replaced (update `src/components/Hero.astro` + real URL)
- [ ] Kindred wordmark/logo SVG added (replace placeholder text in `Footer.astro` + `favicon.svg`)
- [ ] Real favicon PNGs generated (16, 32, 180, 192, 512) — see `public/images/README.txt`
- [ ] OG card image created (`public/images/og-card.png`, 1200×630)
- [ ] Copy voice reviewed by owner (brief §4 — brief copy is ~80% ready, owner sharpens hooks)
- [ ] `/privacy` content synced from the Kindred app repo's `legal/` (canonical) into `src/legal/privacy.md`
- [ ] `/terms` content synced from the Kindred app repo's `legal/` (canonical) into `src/legal/terms.md`
- [ ] Apex serves from **this repo's** GitHub Pages (`public/CNAME` = `kindredhome.app`); the domain is not claimed by any other Pages site
- [ ] `https://kindredhome.app/.well-known/assetlinks.json` returns `200` + `application/json` (Android App Links — see `DEEPLINKS.md`)
- [ ] `sitemap-index.xml` accessible at `https://kindredhome.app/sitemap-index.xml`
- [ ] `robots.txt` accessible at `https://kindredhome.app/robots.txt`
- [ ] OG / Twitter card tested via [opengraph.xyz](https://www.opengraph.xyz) on the live URL
- [ ] Lighthouse mobile: Performance ≥90, Accessibility ≥95, SEO ≥95
- [ ] WCAG 2.1 AA: tab order traversable, all images have `alt`, contrast verified
- [ ] `support@kindredhome.app` mailto link works (test from a real email client)
- [ ] App Store Connect → Marketing URL set to `https://kindredhome.app` (post-launch)
- [ ] Play Console → Store listing → Website set to `https://kindredhome.app` (post-launch)

---

## Design tokens

CSS custom properties in `src/styles/tokens.css` are translated directly from the app's Flutter token files:

| Flutter file | CSS equivalent |
|---|---|
| `lib/ui/theme/app_colors_v2.dart` | `--color-*` properties |
| `lib/ui/theme/app_text_v2.dart` | `--font-*` + `--text-*` properties |
| `lib/ui/theme/app_shape_v2.dart` | `--radius-*`, `--shadow-*`, `--card-*` properties |

If the app's V2 tokens change, update `src/styles/tokens.css` to match.

---

## Privacy / Terms pages

`/privacy` and `/terms` render `src/legal/privacy.md` and `src/legal/terms.md`.
The **canonical content lives in the Kindred app repo's `legal/`** — when it
changes there, mirror the edit into `src/legal/*.md` here and redeploy.

The URL paths `/privacy` and `/terms` must not change — they are referenced by
App Store Connect, Play Console, and the in-app About screen.

---

Maintained by: [mr00jay1-lab](https://github.com/mr00jay1-lab)
Questions: support@kindredhome.app
