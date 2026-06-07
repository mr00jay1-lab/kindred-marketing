# kindred-marketing

Marketing landing site for [Kindred](https://kindredhome.app) — a household management app for iOS and Android.

**Stack:** Astro 4 + TypeScript · Cloudflare Pages · Google Fonts (Fraunces + Inter)
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
│   │   ├── privacy.astro  # /privacy — placeholder, sync from kindred-legal
│   │   ├── terms.astro    # /terms   — placeholder, sync from kindred-legal
│   │   └── 404.astro
│   └── styles/
│       ├── tokens.css     # V2 design tokens → CSS custom properties
│       └── global.css     # Reset + typography + layout utilities
├── astro.config.mjs
├── package.json
└── tsconfig.json
```

---

## Cloudflare Pages deploy

### First-time setup
1. Push this repo to GitHub (`mr00jay1-lab/kindred-marketing`).
2. In Cloudflare Dashboard → Pages → Create a project → Connect to Git.
3. Select the `kindred-marketing` repo.
4. Build settings:
   - **Framework preset:** Astro
   - **Build command:** `npm run build`
   - **Build output directory:** `dist`
   - **Node.js version:** 20 (set in Environment Variables: `NODE_VERSION=20`)
5. Click **Save and Deploy**.

### DNS migration (apex domain switch from GitHub Pages)

The current `kindredhome.app` apex serves from GitHub Pages (`mr00jay1-lab/kindred-legal`).
After the Cloudflare Pages project is live:

1. In Cloudflare Dashboard → Pages → kindred-marketing → Custom Domains → Add `kindredhome.app`.
2. Cloudflare will show you the required DNS records (CNAME or A records).
3. Update DNS in your registrar (or in Cloudflare DNS if already using CF nameservers).
4. Propagation is typically under 5 minutes on Cloudflare DNS.
5. Verify with: `dig kindredhome.app @1.1.1.1` — should resolve to Cloudflare Pages IPs.
6. Verify `/privacy` and `/terms` still resolve at the same paths.

### Subsequent deploys
Push to `main` → Cloudflare Pages automatically builds and deploys. ~30 seconds.

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
- [ ] `/privacy` content synced from `mr00jay1-lab/kindred-legal/docs/privacy_policy.md`
- [ ] `/terms` content synced from `mr00jay1-lab/kindred-legal/docs/terms_of_service.md`
- [ ] Cloudflare Web Analytics token pasted into `src/layouts/Base.astro` (search `TODO: paste Cloudflare`)
- [ ] GitHub repo `mr00jay1-lab/kindred-marketing` created and this code pushed
- [ ] Cloudflare Pages project created and linked to the repo
- [ ] DNS migrated from GitHub Pages to Cloudflare Pages; propagation verified
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

`/privacy` and `/terms` are placeholder pages with clear TODO comments.
The canonical content lives in `mr00jay1-lab/kindred-legal`.
Before launch, sync by copying the rendered Markdown into the respective `.astro` files,
or by adding `kindred-legal` as a git submodule and using `@astrojs/mdx`.

The URL paths `/privacy` and `/terms` must not change — they are referenced by
App Store Connect, Play Console, and the in-app About screen.

---

Maintained by: [mr00jay1-lab](https://github.com/mr00jay1-lab)
Questions: support@kindredhome.app
