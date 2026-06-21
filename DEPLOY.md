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
- `public/CNAME` must stay `kindredhome.app` — it's how **this repo** owns the apex on every deploy. Deleting it lets GitHub Pages drop the custom domain, and the apex can fall back to a host without `/.well-known/assetlinks.json` (the root cause behind the Play deep-link errors and the old `kindred-legal` drift). The workflow guards it.

## History (why DEPLOY_STATUS.md exists)

Until 2026-06-11 the apex was served by GitHub Pages from a **separate repo** (`mr00jay1-lab/kindred-legal`, `main` branch `/docs` folder), and publishing meant hand-copying `dist/` into that repo. That copy step was missed (stale site) and risked dropping `assetlinks.json`. The domain was cut over to this repo + auto-deploy on 2026-06-11; `kindred-legal` is retired and safe to delete.
