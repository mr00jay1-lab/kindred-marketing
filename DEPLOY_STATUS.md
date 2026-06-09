# Deploy status — Kindred marketing graphics handoff

_Last updated: 2026-06-09_

## TL;DR
The six-asset design handoff is **fully integrated and merged to `main`**, and the
repo's `gh-pages` branch is rebuilt. **The live apex `kindredhome.app` still shows
the old site** because the apex is served by GitHub Pages from a **separate repo
(`mr00jay1-lab/kindred-legal`)**, which was out of scope for the session that did
this work. One deployment step remains (see "To finish").

## What was delivered (code)
Integrated on branch `claude/code-review-76xre9`, merged via PR #1 to `main`:

- All 6 assets in `public/images/`: `section-ai.png`, `section-shopping.png`,
  `section-chores.png`, `hero-accent.png`, the real `og-card.png` (1200x630, ~371 KB,
  replacing the old ~33 KB placeholder), `feature-graphic-light.jpg`.
- **Hero accent** — transparent power-button glow added as a decorative,
  `aria-hidden` layer behind the hero (`Hero.astro` + responsive CSS in `site.css`).
- **Three pillar scenes** rendered full-bleed: AI (`GradientMagicBand.astro`),
  Shopping & Chores (`DeepDiveRow.astro` via a new `banner` prop). Each scene bakes
  its eyebrow + headline into the raster, so the live copy is preserved in a
  `.visually-hidden` block (heading ids kept for `aria-labelledby`) — no visible
  duplicate headline. Interactive elements stay live: the AI "Try Plan Next Week"
  CTA + privacy links, and the Shopping `StepFlow`.
- New `.visually-hidden` utility in `global.css`.
- `og-card.png` was already wired in `Base.astro` (`og:image` / `twitter:image`);
  dropping the real file completed it.
- `feature-graphic-light.jpg` included as an unreferenced press/banner asset.
- `npm run build` passes clean.

### Design note
These section images are full scenes with headline text baked into the raster.
That text does not reflow and is not selectable, so legibility on very narrow
mobile widths is the one thing to keep an eye on. If it ever reads too small, the
rows can revert to the live semantic layout (remove the `banner` props on the
`DeepDiveRow`s and revert `GradientMagicBand.astro`) and these scenes can be used
as social/blog art instead.

## Git state (repo: `mr00jay1-lab/kindred-marketing`)
| Ref         | Commit                                   | Status                          |
|-------------|------------------------------------------|---------------------------------|
| PR #1       | —                                        | Merged                          |
| `main`      | `fbd7061` (+ `b3569dc` empty CI trigger)  | Has all changes                 |
| `gh-pages`  | `28c5180`                                | Rebuilt & pushed (fresh build)  |

## Why kindredhome.app is still stale (root cause)
1. Merging to `main` does not deploy anything on its own.
2. The deploy branch `gh-pages` is hand-published (no CI), so `main` and
   `gh-pages` had drifted. It was rebuilt to `28c5180` — apex **still 404'd**.
3. `kindred-marketing/gh-pages` has **no `CNAME`**, so it does not own the domain.
4. Per `PREVIEW.md` / `README.md`, **`kindredhome.app` is GitHub Pages served from
   `mr00jay1-lab/kindred-legal`** (from its `docs/` folder).

=> The live apex is owned by `kindred-legal`. To publish these graphics, the fresh
`dist/` must be copied into `kindred-legal/docs/` (preserving its `CNAME`).

## Where we got stuck
- `mr00jay1-lab/kindred-legal` was **outside the session's GitHub scope** (access
  hard-locked to `kindred-marketing`).
- The session repo-management tool (`list_repos` / `add_repo`) was **not available**.
- The sandbox network blocked outbound requests, so the live site could not be
  fetched and external deploy CLIs (Vercel login, Playwright/Chromium download)
  were blocked too.

This is a deployment-routing / permissions gap, **not a code issue** — the work is
done and verified in-repo.

## To finish (pick one)
1. **Add `mr00jay1-lab/kindred-legal` to the session scope**, then push the built
   `dist/` into `kindred-legal/docs/` (keep `CNAME` + `.nojekyll`). Fastest path live.
2. **Manual deploy** — locally:
   ```sh
   # in kindred-marketing
   npm run build
   # into your kindred-legal checkout (confirm Pages source dir first):
   cp kindred-legal/docs/CNAME /tmp/CNAME            # preserve domain
   rm -rf kindred-legal/docs && mkdir kindred-legal/docs
   cp -a dist/. kindred-legal/docs/
   cp /tmp/CNAME kindred-legal/docs/CNAME
   touch kindred-legal/docs/.nojekyll
   cd kindred-legal && git add -A \
     && git commit -m "Deploy marketing site update" && git push
   ```
3. **Repoint the domain** off the manual `kindred-legal` hop onto the
   `kindred-marketing` Cloudflare Pages (or its `gh-pages`) so it auto-deploys on
   push — one-time DNS/Pages settings change.

## Recommended permanent fix
Eliminate the `main` vs `gh-pages` vs `kindred-legal` drift: repoint the apex to a
single auto-deploying source (option 3) and add a GitHub Action so a push to `main`
auto-publishes the build. Until then, remember the apex deploy is a **separate,
manual step in `kindred-legal`**.

## Quick verification
After deploying to the correct target, hard-refresh:
`https://kindredhome.app/images/section-ai.png` — it should load (200), not 404.
