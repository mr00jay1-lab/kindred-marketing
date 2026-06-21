# Android App Links / Play deep-link verification — runbook

The website half of Android App Links lives here:
`public/.well-known/assetlinks.json` → served at
`https://kindredhome.app/.well-known/assetlinks.json`.

This file is **already correct** (valid JSON, package `com.kindredhome.app`,
a 64-hex SHA-256, no BOM) and is **byte-identical to the app-repo canonical**.
CI guards its presence + validity on every deploy. So the open issues are
**hosting/serving**, not file content.

## Cross-repo status (as of 2026-06-21)

| Piece | Owner | Status |
|---|---|---|
| `/join` "Failed format checks" (intent-filter) | **app repo** | ✅ Fixed — shipping in build **1.0.3+55** to Internal + Closed testing |
| "Digital Asset Links JSON file failed" (reachability) | **website (here)** | ⏳ hosting — verify with `scripts/verify-deeplinks.sh` once egress is allowed |
| "JSON content type failed" (MIME) | **website (here)** | ⏳ hosting — `public/_headers` forces `application/json` on non-GitHub-Pages hosts |

**Source of truth:** the canonical `assetlinks.json` lives in the **app repo** at
`legal/.well-known/assetlinks.json` and mirrors to
`public/.well-known/assetlinks.json` here (same convention as `src/legal/*.md`).
When the app repo changes it (e.g. adds a fingerprint), mirror the exact bytes
here. They are currently identical.

> ⚠️ The CI guard validates file *content*, not the *served* Content-Type — a
> present-but-`text/plain` file would pass the build but still fail Play. Only
> `scripts/verify-deeplinks.sh` (live HTTP) catches a served-MIME regression.
> `public/_headers` pins `application/json` on Cloudflare Pages / Netlify.

## The two Play Console errors and what they mean

Play Console → **Test and release → Grow → Deep links → `kindredhome.app`**:

| Play Console error | Real meaning | Fix |
|---|---|---|
| **Digital Asset Links JSON file failed** | Google didn't get a clean `200` for the file at the apex — it got a redirect or a 404. | Make the file reachable with a **direct 200** (no redirect) at `https://kindredhome.app/.well-known/assetlinks.json`. |
| **JSON content type failed** | The response wasn't `application/json` — almost always because the request landed on the HTML 404 page or a redirect, not the real file. | Same root cause as above; once the real JSON file is served, GitHub Pages sends `application/json` automatically. |

Both errors share one root cause: **the apex is probably still fronted by the
old host** (Cloudflare Pages / `kindred-legal`, per `DEPLOY_STATUS.md`) which
does not have `.well-known/assetlinks.json`, instead of **this repo's GitHub
Pages deploy**, which does.

> `/join` also shows **"Failed format checks"** — that is the
> `<intent-filter>` in the **Android app's `AndroidManifest.xml`**, NOT this
> repo. See the bottom section.

## Do-it-in-advance checklist (already done in this repo)

- [x] `assetlinks.json` present, valid, correct package + 64-hex fingerprint.
- [x] CI guard validates JSON content (not just existence) before every deploy.
- [x] `scripts/verify-deeplinks.sh` reproduces Google's exact checks against the
      live site in one command.

## The moment egress / production is allowed — minimal steps

1. **Confirm the apex actually serves the file from this repo's Pages.** From a
   machine with network access (or this environment once `kindredhome.app` is on
   the egress allowlist):

   ```sh
   ./scripts/verify-deeplinks.sh
   ```

   - **All checks pass** → skip to step 3 (just re-verify in Play).
   - **404 / redirect / wrong content-type** → the apex is not served by this
     repo's Pages. Do step 2.

2. **Point the apex at this repo's GitHub Pages (one-time):**
   - GitHub → this repo → **Settings → Pages** → Custom domain = `kindredhome.app`,
     **Enforce HTTPS** on.
   - DNS at the registrar: apex `A` → `185.199.108–111.153`, `www` `CNAME` →
     `mr00jay1-lab.github.io`. Remove any Cloudflare **proxy (orange cloud)** or
     redirect rule on `/.well-known/*` that could intercept the path.
   - Re-run `./scripts/verify-deeplinks.sh` until it's all green.

3. **Re-verify in Play Console:** Deep links → `kindredhome.app` →
   **Re-verify**. (Published apps may also need a new release + users updating
   before links route in-app — Play states this on that screen.)

## Fingerprint note (only if a *fingerprint* error appears)

The current errors are **not** fingerprint errors, so the SHA-256 in the file is
assumed correct. If Play ever reports a **fingerprint/cert mismatch**, copy the
ready-made snippet from Play Console → **Setup → App integrity → App signing →
Digital Asset Links JSON**, and make `public/.well-known/assetlinks.json` match
it. With Play App Signing you usually want **both** the app-signing key and the
upload key fingerprints in the `sha256_cert_fingerprints` array.

## The `/join` "Failed format checks" (Android app repo — not here)

This is the deep-link `<intent-filter>` on `MainActivity`. It must look like
(adjust host/path to taste):

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https"
          android:host="kindredhome.app"
          android:pathPrefix="/join" />
</intent-filter>
```

Common format-check failures: missing `android:autoVerify="true"`, missing
`BROWSABLE` category, or `scheme`/`host` split into separate `<data>` tags in a
way Play can't parse. Fix this in the **Kindred app repo**, not here.
