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

## How it's hosted (important)
`kindredhome.app` is served by GitHub Pages from the **`mr00jay1-lab/kindred-legal`** repo
(`docs/` on `main`, with the `CNAME`). The built marketing site lives there now (`.nojekyll`
+ the Astro `dist`), **replacing the old legal-only Jekyll site** — same domain, same cert,
no DNS change.

- **Site SOURCE** → `mr00jay1-lab/kindred-marketing` (`main`). Edit + `npm run build` here.
- **Apex DEPLOY** → copy this repo's `dist/*` into `kindred-legal/docs/` (keep `CNAME` +
  `.well-known/assetlinks.json` + add `.nojekyll`), commit + push `kindred-legal` `main`.
- `/privacy` + `/terms` render the canonical legal markdown (`src/legal/*.md`, synced from
  the Kindred repo's `legal/`), so the store-referenced URLs are unchanged. App Links
  `/.well-known/assetlinks.json` is preserved + still Google-verified.

### ⚠️ New legal-edit flow (changed by the apex move)
Legal edits now flow: Kindred repo `legal/*.md` (canonical) → copy into
`kindred-marketing/src/legal/*.md` → `npm run build` → redeploy `dist` to `kindred-legal/docs`.
(Previously you edited `kindred-legal/docs/privacy.md` directly under Jekyll.)

## Still to do before public launch (owner)
- **Swap the placeholder store badges** (`src/components/StoreBadges.astro`) for official
  Apple/Google artwork + real store URLs (they currently link to `#`; apps aren't public yet).
- Optional: a dedicated marketing identity, real testimonials, a promo video.
- The Cloudflare-Pages route in `marketing_site_brief.md` is now **optional** — the apex is
  already served from GitHub. Move to Cloudflare later only if you want its analytics/edge.

## Rollback
If anything on the apex needs reverting: `git -C kindred-legal revert df20ba8` (or reset to
`1fce9e6`) + push — restores the previous legal-only site.
