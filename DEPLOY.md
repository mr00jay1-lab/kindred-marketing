# How kindredhome.app is published

_Effective 2026-06-11. Supersedes the manual two-repo flow described in `DEPLOY_STATUS.md` (kept as history)._

## TL;DR

**This repo (`kindred-marketing`) is the single source of truth AND the host.**
Push to `main` → GitHub Actions builds the Astro site → deploys to GitHub Pages → live at https://kindredhome.app within ~2 minutes. No other repo is involved.

```
src/ + public/  --push to main-->  .github/workflows/deploy.yml  -->  GitHub Pages  -->  kindredhome.app
```

## The pieces

| Piece | Where | Notes |
|---|---|---|
| Site source | `src/` (Astro 4, static output) | Pages: `/`, `/features`, `/privacy`, `/terms`, `404` |
| Legal copy | `src/legal/privacy.md` + `terms.md` | **Canonical source lives in the Kindred app repo (`Kindred/legal/`)** — when that changes, mirror the edit here |
| Static assets | `public/` | Copied verbatim into the build — images, favicons, robots.txt |
| **Android App Links** | `public/.well-known/assetlinks.json` | **MUST stay at this exact path.** Google Play / Android verify `https://kindredhome.app/.well-known/assetlinks.json` (package `com.kindredhome.app` + release SHA-256). The CI guard step fails the build if it's missing from `dist/` |
| Deploy workflow | `.github/workflows/deploy.yml` | Build + deploy on every push to `main` (also manual via Actions → "Run workflow") |
| Custom domain | **`public/CNAME`** (→ `dist/CNAME`) = `kindredhome.app` | **The repo owns the apex.** The tracked `CNAME` file is re-asserted on every deploy so the domain can't silently drop to another Pages site (e.g. the retired `kindred-legal`). A CI guard fails the build if it's missing or wrong. Settings → Pages mirrors it; HTTPS enforced |
| DNS | Registrar: apex `A` → 185.199.108/109/110/111.153, `www` CNAME → `mr00jay1-lab.github.io` | Already set; don't touch |

## Day-to-day: making a site change

1. Edit in this repo (work on a branch or directly on `main`).
2. `npm run dev` to preview locally (or `npm run build && npm run preview`).
3. Land on `main` and push.
4. Watch Actions → "Deploy to GitHub Pages" go green (~2 min).
5. Hard-refresh https://kindredhome.app (Pages caches for 10 min — check the `Last-Modified` header if unsure).

## Things that must never regress

- `public/.well-known/assetlinks.json` — deleting/moving it breaks Android App Links + Play Store deep-link verification. The workflow has a guard step that fails the build if it's absent.
- `/privacy` and `/terms` must stay reachable — they're linked from App Store Connect + Play Console.
- `public/CNAME` must stay `kindredhome.app` — it's how **this repo** owns the apex on every deploy. Deleting it lets GitHub Pages drop the custom domain. The workflow guards it.
- `public/.nojekyll` must exist — **without it GitHub Pages hides dot-folders, so `/.well-known/assetlinks.json` 404s** even though the file is in the build. This is the regression that broke Android App Links after the move to the Actions deploy. The workflow guards it.

## History (the lesson)

The apex used to be served by GitHub Pages from a **separate, retired repo** and published by hand-copying `dist/` into it — which drifted, went stale, and risked dropping `assetlinks.json`. Ownership lived only in a Pages **setting**, so the domain could silently fall back to that other site (with no App Links file) — the root cause behind the Play deep-link errors. The durable fix is in place: this repo auto-deploys on push to `main` and **pins the apex with a tracked `public/CNAME`**, guarded in CI. The retired repo must not hold the `kindredhome.app` custom domain — if the apex 404s, confirm no other Pages site claims it.
