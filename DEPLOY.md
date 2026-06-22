# How kindredhome.app is published

**This repo (`kindred-marketing`) is the single source of truth AND the host.**
Push to `main` → GitHub Actions builds the Astro site → deploys to GitHub Pages →
live at https://kindredhome.app in ~2 minutes. No other repo is involved.

```
src/ + public/  --push to main-->  .github/workflows/deploy.yml  -->  GitHub Pages (Source: GitHub Actions)  -->  kindredhome.app
```

## The pieces

| Piece | Where | Notes |
|---|---|---|
| Site source | `src/` (Astro 4, static output) | Pages: `/`, `/features`, `/privacy`, `/terms`, `404` |
| Legal copy | `src/legal/privacy.md` + `terms.md` | **Canonical source lives in the Kindred app repo's `legal/`** — when that changes, mirror the edit here |
| Static assets | `public/` | Copied verbatim into the build — images, favicons, robots.txt |
| **Android App Links** | `public/.well-known/assetlinks.json` | Served at `https://kindredhome.app/.well-known/assetlinks.json` (package `com.kindredhome.app` + the Play **app-signing** SHA-256). See `DEEPLINKS.md`. |
| Deploy workflow | `.github/workflows/deploy.yml` | Build + deploy + live verify on every push to `main` (also manual via Actions → "Run workflow") |
| Custom domain | `public/CNAME` (→ `dist/CNAME`) = `kindredhome.app` | The repo owns the apex; re-asserted every deploy, guarded in CI |
| Pages Source | **Settings → Pages → Source = "GitHub Actions"** | Must stay "GitHub Actions". **Never** switch to "Deploy from a branch" |
| DNS | Registrar: apex `A` → 185.199.108/109/110/111.153, `www` CNAME → `mr00jay1-lab.github.io` | Already set; don't touch |

## Day-to-day: making a site change

1. Edit in this repo (branch or directly on `main`).
2. `npm run dev` to preview (or `npm run build && npm run preview`).
3. Land on `main` and push.
4. Watch Actions → "Deploy to GitHub Pages" go green (~2 min). The `verify-live`
   job at the end actually fetches the apex and fails loudly if it's wrong.
5. Hard-refresh https://kindredhome.app (Pages/Fastly cache ~10 min).

## Guardrails (the workflow enforces these — don't remove them)

The deploy workflow fails the build, or warns loudly, if any of these regress:

1. **`public/.well-known/assetlinks.json`** — present, valid JSON, package
   `com.kindredhome.app`, a 64-hex SHA-256, no BOM.
2. **`public/.nojekyll`** — present (stops GitHub Pages Jekyll-processing the output).
3. **`public/CNAME`** = `kindredhome.app` — pins apex ownership to this repo.
4. **Hidden files survive into the artifact** — we package the Pages tarball
   ourselves and assert `.well-known/assetlinks.json` is inside it (see lesson #3).
5. **`verify-live`** — after deploy, curls `https://kindredhome.app/.well-known/assetlinks.json`
   and checks for a real `200 application/json`. This catches a broken apex even
   when the build looks green.

`/privacy` and `/terms` must also stay reachable — they're linked from App Store
Connect + Play Console.

## Hard-won lessons (why the guardrails exist)

These are the exact failures that have bitten this site. Don't reintroduce them.

1. **Apex ownership must live in the repo, not a UI setting.** The apex once
   served from a separate, now-retired repo, with ownership in a Pages *setting*
   that could silently drop. Fix: the tracked `public/CNAME` re-claims the apex on
   every deploy. If the apex ever 404s, confirm no *other* Pages site claims
   `kindredhome.app`.

2. **GitHub Pages hides dot-folders without `.nojekyll`.** Add `public/.nojekyll`
   so `/.well-known/` is served.

3. **`actions/upload-pages-artifact` strips hidden files.** This was the real
   cause of the Play deep-link 404: the assetlinks file was in `dist/` and passed
   every content guard, but the upload action excluded `.well-known/` and
   `.nojekyll` from the published artifact, so the live apex returned the 404 page
   for it. **Fix:** the workflow packages the tarball manually with GNU `tar`
   (which keeps dotfiles) and uploads that — and asserts the file is in the tar.
   **Do not** replace that step with `actions/upload-pages-artifact` again.

4. **Pages Source must be "GitHub Actions".** If it's ever set to "Deploy from a
   branch", GitHub serves that branch (stale) while the Actions workflow reports
   success but is ignored. A leftover **`gh-pages` branch** (commit `28c5180`)
   once caused exactly this. It's now inert (Source is "GitHub Actions"), but it
   should be **deleted** — repo → Branches → trash icon — and no deploy branch
   should ever be recreated.

## Verifying the apex by hand

```sh
curl -sSI https://kindredhome.app/.well-known/assetlinks.json   # want: 200 + content-type: application/json
# Google's verifier (the exact service Play uses):
curl -s "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://kindredhome.app&relation=delegate_permission/common.handle_all_urls"
```

`scripts/verify-deeplinks.sh` runs all of these in one command.
