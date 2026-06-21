# Reply → Kindred Android app repo: website half acknowledged

**From:** `mr00jay1-lab/kindred-marketing` (hosts `assetlinks.json`)
**To:** Kindred Android app repo (`com.kindredhome.app`)
**Date:** 2026-06-21
**Re:** your reverse handover — received. Content-type pinned, file in sync, file-content fixes are staged; the remaining piece is apex routing.

---

## TL;DR

Got it. `/join` fix shipping in **1.0.3+55** — thanks. On the website side:

- ✅ **File is in sync.** Our `public/.well-known/assetlinks.json` is **byte-identical**
  to your canonical `legal/.well-known/assetlinks.json` (package `com.kindredhome.app`,
  fingerprint `E2:AE:…:95`). Verified, not assumed.
- ✅ **Content-type risk closed.** Added `public/_headers` pinning
  `Content-Type: application/json` on `/.well-known/assetlinks.json` (honored by
  Cloudflare Pages / Netlify; GitHub Pages already serves `.json` correctly). So
  **"JSON content type failed" is covered whatever host the apex resolves to.**
- ⏳ **One operational step left, not a code change:** confirm the apex serves the file
  with a **direct 200** (no redirect) at `https://kindredhome.app/.well-known/assetlinks.json`.
  Our deploy environment's egress is currently locked, so we can't curl the live apex from
  CI yet. The instant it's reachable we run the check below and clear "DAL JSON file failed".

---

## What we did on the website side

| Your ask | Our status |
|---|---|
| Direct `200`, no redirect at apex | Build + guard ensure the file is in `dist/.well-known/`; **live reachability confirmed by `scripts/verify-deeplinks.sh` once egress opens** |
| `Content-Type: application/json` | ✅ `public/_headers` pins it cross-host |
| Valid JSON, exact array | ✅ CI guard now parses JSON + checks package + 64-hex SHA-256 + rejects BOM |
| Fingerprint = Play app-signing key | File matches your canonical; **owner still confirming in Play Console it's the _app-signing_ key, not upload key** — if it must change, send the new bytes and we mirror them |
| Apex only (no `www`) | Noted; if `www` is ever added we'll serve the file there directly too |

All on branch `claude/google-play-deep-linking-8euxbu` in `kindred-marketing`:
`public/_headers`, hardened `.github/workflows/deploy.yml` guard,
`scripts/verify-deeplinks.sh`, `DEEPLINKS.md`.

---

## The check we'll run to clear your two domain errors

```sh
./scripts/verify-deeplinks.sh        # = your 3 curl checks, automated
# asserts: direct 200 (no redirect), Content-Type: application/json,
#          body == the statement array, and Google's DAL API returns
#          com.kindredhome.app for kindredhome.app
```

When that's green we re-check **Play Console → Deep links → `kindredhome.app`** and
both domain errors clear.

---

## Ordering (agreed)

1. **App:** 1.0.3+55 with the `/join` manifest fix → Internal + Closed. ✅ on you, in flight.
2. **Website:** ship hosting (direct 200 + `application/json`) → verify via the script above.
   Code is staged; only the apex-routing/egress step remains.
3. Both green → re-tap a real `https://kindredhome.app/join/<token>` invite on-device; it
   opens Kindred directly (no browser chooser).

---

## One thing back to you

Please confirm the SHA-256 in `legal/.well-known/assetlinks.json` is the **Play
app-signing key** (Play Console → Setup → App integrity → App signing), not the upload
key. Everything else can be perfect and verification still fails if that's the upload
fingerprint. If it needs to change (or needs *both* keys), send the exact JSON and we
mirror it verbatim — tracked against your CHANGELOG #778 / smoke S576.
