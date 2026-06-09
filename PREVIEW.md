# 🌐 Kindred marketing site — live preview

## 👉 https://mr00jay1-lab.github.io/kindred-marketing/

Open it on your phone or desktop. Also try the full tour: **/features/**.

Built overnight (2026-06-08 → 09) as an autonomous session. Content-rich landing
page at **cozi.com density**, rendered in Kindred's upgraded **"Modern Cozy V2"**
style (navy `#001A57` / teal `#2BB98B` / coral `#FC7E50` brand layer over sage/cream).

## What's on the page (17 sections)
Sticky nav · hero (with the week calendar) · trust strip · "the mental load is real"
empathy band · 3 differentiator pillars · **Meals & calendar** deep-dive · the navy
**✨ AI Plan-next-week** magic band · real-screenshot **gallery** (with a Light/Dark
toggle) · **Shopping & stock** deep-dive (+ 3-step flow) · **Chores** deep-dive ·
**Recipes & AI** · **One household, one price** · **Pricing** (Free / Premium) ·
**Trust** (private, no ads, UK-built) · **FAQ** (8 Q&As + schema.org rich-result JSON-LD)
· final CTA · navy footer. Plus a `/features` full tour (all 17 app screenshots).

Uses **20 real app screenshots** (the dark v0.3.0+30 set + 3 light shots), generated
favicons, and an OG share card. Designed by a 5-persona workflow (content strategist,
art director, information architect, copywriter, lead designer); built parent-direct.

## ⚠️ This is a PREVIEW — three things to know
1. **It's on a GitHub Pages preview URL, not `kindredhome.app`.** The brief's target is
   Astro on **Cloudflare Pages** at the apex — that needs your Cloudflare login + DNS,
   so it's your step (see `tasks/marketing_site_brief.md §3`). `/privacy` + `/terms`
   are live here too.
2. **Store badges are tasteful approximations, not official artwork**, and link to `#`
   (the apps aren't public yet). Swap in the official Apple/Google badges + real store
   URLs before launch (`src/components/StoreBadges.astro`).
3. **OG/canonical tags point at `kindredhome.app`** (the real future home) — cosmetic on
   this preview URL.

## How it's wired
- **Source** → `main` branch (Astro project).
- **Built site** → `gh-pages` branch (post-processed for the `/kindred-marketing` subpath
  + `.nojekyll` so the `_astro/` assets serve). GitHub Pages serves `gh-pages` at root.
- Design tokens: `src/styles/tokens.css` (mirrors `lib/ui/theme/app_colors_v2.dart`).
  Site composition: `src/styles/site.css`.

## To iterate / redeploy
```bash
cd kindred-marketing
npm run build                      # rebuild dist/
# then re-run the subpath post-process + push gh-pages (see the agent's _postprocess_dist.cjs),
# OR once on Cloudflare Pages at the apex, drop the subpath step entirely.
```

## To ship for real (production, per the brief)
Create a Cloudflare Pages project from this repo (`main`, build `npm run build`, output
`dist`), point `kindredhome.app` DNS at it, and the subpath post-process goes away (the
apex serves from root). `/privacy` + `/terms` keep the same URLs.
