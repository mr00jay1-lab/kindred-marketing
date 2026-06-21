# 🌐 Kindred marketing site — LIVE

## 👉 https://kindredhome.app/

**Live on the real apex domain** (since 2026-06-09). Also: the full tour at **/features**,
and the staging mirror at https://mr00jay1-lab.github.io/kindred-marketing/.

Content-rich landing page at **cozi.com density**, in Kindred's upgraded **"Modern Cozy V2"**
style (navy `#001A57` / teal `#2BB98B` / coral `#FC7E50` over sage/cream). Built overnight
(2026-06-08 → 09) as an autonomous session.

## What's on the page (17 sections)
Sticky nav · hero (week calendar) · "the mental load is real" empathy band · 3 differentiator
pillars · **Meals & calendar** deep-dive · the navy **✨ AI Plan-next-week** magic band ·
real-screenshot **gallery** (Light/Dark toggle) · **Shopping & stock** (+ 3-step flow) ·
**Chores** · **Recipes & AI** · **One household, one price** · **Pricing** (Free / Premium) ·
**Trust** · **FAQ** (8 Q&As + schema.org rich-result JSON-LD) · final CTA · navy footer.
Plus a `/features` full tour (all 17 app screenshots). 20 real app screenshots, generated
favicons + OG card. Designed by a 5-persona workflow; built parent-direct.

## How it's hosted
**This repo is the source AND the host.** Push to `main` → GitHub Actions builds
the Astro site → deploys to GitHub Pages → live at `kindredhome.app`. The apex is
owned by the tracked `public/CNAME`. Full process in **`DEPLOY.md`**; Android App
Links / Play deep-link details in **`DEEPLINKS.md`**.

- **Site SOURCE + HOST** → `mr00jay1-lab/kindred-marketing` (`main`). Edit, push, done.
- `/privacy` + `/terms` render `src/legal/*.md` (canonical content mirrored from the
  Kindred app repo's `legal/`), so the store-referenced URLs are unchanged. App Links
  `/.well-known/assetlinks.json` ships in the build and is CI-guarded.

## Still to do before public launch (owner)
- **Swap the placeholder store badges** (`src/components/StoreBadges.astro`) for official
  Apple/Google artwork + real store URLs (they currently link to `#`; apps aren't public yet).
- Optional: a dedicated marketing identity, real testimonials, a promo video.

## Rollback
Revert the offending commit on `main` and push — the deploy workflow republishes
automatically. No separate host or manual copy step is involved.
