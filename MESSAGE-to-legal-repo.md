# Message → `mr00jay1-lab/kindred-legal`: release the apex, then delete this repo

**To:** whoever/whatever owns `mr00jay1-lab/kindred-legal`
**From:** `mr00jay1-lab/kindred-marketing` (the new single source **and** host for `kindredhome.app`)
**Date:** 2026-06-21

## What's happening

`kindred-marketing` is now the source **and** host for `kindredhome.app` (Astro →
GitHub Actions → GitHub Pages, auto-deploy on push to `main`). We're retiring
`kindred-legal` entirely and keeping everything in `kindred-marketing`.

**Right now the apex 404s** on `https://kindredhome.app/.well-known/assetlinks.json`,
which is breaking Google Play deep-link verification. Root cause: **`kindred-legal`'s
GitHub Pages site still claims the `kindredhome.app` custom domain.** GitHub Pages
domains are exclusive — until `kindred-legal` releases it, `kindred-marketing`'s
deploys (which DO contain the file) never reach the live apex.

So we need one thing from you first: **release the domain.** Then delete the repo.

## Do these IN ORDER

**1. Release the custom domain (this is the unblock).**
   - `kindred-legal` → **Settings → Pages → Custom domain** → clear `kindredhome.app` → **Save**.
   - Delete the Pages `CNAME` file if present (likely `docs/CNAME`), and commit.
   - Optionally set **Pages → Source = None** to disable Pages on this repo entirely.

**2. Don't touch DNS.** The apex `A` records already point to GitHub Pages' shared
   IPs (`185.199.108–111.153`) and `www` CNAME → `mr00jay1-lab.github.io`. Those are
   shared across all GitHub Pages sites, so once `kindred-legal` releases the domain
   and `kindred-marketing` claims it, the *same* DNS resolves to the new site. No
   registrar change.

**3. Confirm nothing unique is lost** (everything should already live in `kindred-marketing`):
   - **Privacy/Terms:** canonical content is the **Kindred app repo's `legal/`**, mirrored to
     `kindred-marketing/src/legal/*.md` and served at `/privacy` and `/terms`. `kindred-legal`'s
     copies are **not** canonical.
   - **App Links:** `assetlinks.json` lives at `kindred-marketing/public/.well-known/assetlinks.json`
     (`com.kindredhome.app`, Play app-signing SHA-256). Already correct.
   - If `kindred-legal` holds anything else still referenced anywhere, copy it into
     `kindred-marketing` **before** deleting.

**4. If GitHub blocks the handoff** with "domain already taken / verified": check
   **GitHub account → Settings → Pages → Verified domains** and remove/transfer any
   `kindredhome.app` verification tied to `kindred-legal`.

**5. Delete the repo.** Once `https://kindredhome.app/.well-known/assetlinks.json`
   returns `200` from `kindred-marketing` (verify command below), delete `kindred-legal`
   via **Settings → Danger Zone → Delete this repository**.

## What happens on our side automatically

`kindred-marketing` ships a **tracked `public/CNAME` = `kindredhome.app`**, re-asserted
on every deploy, so the moment you release the domain our next deploy claims the apex —
no manual step needed here.

## Verify (either side)

```sh
curl -sSI https://kindredhome.app/.well-known/assetlinks.json
# want: HTTP/2 200  +  content-type: application/json   (NO 301/302, NO 404)
```

When that's green, the apex is served by `kindred-marketing` and Play deep-link
verification can be re-run. **Ping back once the domain is released** and we'll confirm.
