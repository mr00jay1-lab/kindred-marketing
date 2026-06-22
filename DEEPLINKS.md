# Android App Links / Play deep-link verification

**Status: RESOLVED & verified (2026-06-22).** Google's Digital Asset Links API
returns a valid statement for `kindredhome.app` → `com.kindredhome.app`, and Play
Console shows no deep-link issues. This doc is the runbook for keeping it that way.

## How it works

| Half | Where | Detail |
|---|---|---|
| **Website** (this repo) | `public/.well-known/assetlinks.json` | Served at `https://kindredhome.app/.well-known/assetlinks.json` as `application/json`. Package `com.kindredhome.app` + the Play **app-signing** SHA-256. |
| **App** (Kindred app repo) | `AndroidManifest.xml` `<intent-filter>` on `MainActivity` | `autoVerify="true"`, `https://kindredhome.app/join`. Shipped in build **1.0.3+55**. |

The website file is the **mirror** of the canonical copy in the Kindred app repo's
`legal/.well-known/assetlinks.json`. If the app repo changes it (e.g. adds a
fingerprint), copy the exact bytes here. The SHA-256 is the **Play app-signing
key** (confirmed) — not the upload key.

## What actually broke it (and the guardrails that prevent recurrence)

The file content was always correct. The failures were all in **hosting**:

1. The apex was once served by a different (retired) Pages site with no
   `.well-known/` → now pinned to this repo via tracked `public/CNAME`.
2. GitHub Pages hides dot-folders without `.nojekyll` → `public/.nojekyll` added.
3. **`actions/upload-pages-artifact` stripped hidden files** from the published
   artifact, so the apex returned the 404 page for `assetlinks.json` even though
   it was in `dist/` → the workflow now packages the tarball manually and asserts
   the file is inside it.

All three are enforced by `deploy.yml` (build guards + a post-deploy `verify-live`
job that curls the apex). See `DEPLOY.md` → "Hard-won lessons". **Do not** revert
those guards or swap the manual artifact step back to `upload-pages-artifact`.

## Verify any time (one command)

```sh
./scripts/verify-deeplinks.sh
```

It checks the live apex for a direct `200 application/json`, validates the body,
and cross-checks Google's Digital Asset Links API (the exact service Play uses).
By hand:

```sh
curl -sSI https://kindredhome.app/.well-known/assetlinks.json
curl -s "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://kindredhome.app&relation=delegate_permission/common.handle_all_urls"
```

## If a deep-link error ever reappears in Play Console

1. Run `./scripts/verify-deeplinks.sh` (or the curls above).
   - **Not `200 application/json`** → hosting regressed. Check, in order: the last
     `deploy.yml` run's `verify-live` job; Settings → Pages Source is still
     "GitHub Actions"; no other Pages site claims `kindredhome.app`.
2. **Fingerprint/cert mismatch** → copy the snippet from Play Console → **Setup →
   App integrity → App signing → Digital Asset Links JSON** and make
   `public/.well-known/assetlinks.json` match (you usually want both the
   app-signing and upload-key fingerprints in the array). Re-deploy.
3. **`/join` "Failed format checks"** → that's the app's `<intent-filter>`, fixed
   in the **Kindred app repo**, not here. It needs `autoVerify="true"`, both
   `DEFAULT` + `BROWSABLE` categories, and `scheme`/`host`/`pathPrefix` in one
   `<data>` element.
4. After any fix, Play Console → Deep links → `kindredhome.app` → **Re-verify**.
   Published apps may need a new release + users updating before links route.
