# Handover → Kindred Android app repo: Play deep-link verification

**From:** `kindred-marketing` (the website/`assetlinks.json` host)
**To:** whoever owns the Android app (`com.kindredhome.app`) repo
**Date:** 2026-06-21

## Why you're getting this

Play Console → **Test and release → Deep links → `kindredhome.app`** shows
three errors. They split cleanly across two repos:

| Error in Play Console | Owned by | Status |
|---|---|---|
| Domain "Digital Asset Links JSON file failed" | **website** (`kindred-marketing`) | Hosting fix in progress — see that repo's `DEEPLINKS.md` |
| Domain "JSON content type failed" | **website** (`kindred-marketing`) | Same hosting fix |
| Web link `/join` "Failed format checks" | **this app repo** | **YOUR action — details below** |

The website half is being handled. **This handover is only about the app-side
`/join` "Failed format checks" error** and the app/website contract you need to
keep in sync.

## The website contract (what the app must match)

The site already serves (or will serve) this at
`https://kindredhome.app/.well-known/assetlinks.json`:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.kindredhome.app",
      "sha256_cert_fingerprints": [
        "E2:AE:BD:D8:E7:39:BA:32:52:46:55:E4:9A:C3:40:DC:3C:A3:8A:9C:B0:DF:68:05:2C:7B:E3:68:B8:DA:9F:95"
      ]
    }
  }
]
```

So the app side **must** use, exactly:
- **Package:** `com.kindredhome.app`
- **Host:** `kindredhome.app` (apex, no `www`) — this is the host shown on the
  failing `/join` link, targeting `com.kindredhome.app/.MainActivity`.
- **Scheme:** `https`
- **Signing cert SHA-256:** must equal the fingerprint above. ⚠️ With **Play
  App Signing**, the on-device cert is the *Play app-signing key*, not your
  upload key. Confirm the fingerprint above is your **app-signing key**
  (Play Console → Setup → App integrity → App signing). If your release/upload
  key differs, the website list should include **both** — tell the website
  owner which to add.

## Fix the `/join` "Failed format checks" — `AndroidManifest.xml`

"Format checks" = Play couldn't parse a valid App Links intent-filter for the
declared web link. Put this on the activity that handles `/join` (the failing
link points at `.MainActivity`):

```xml
<activity
    android:name=".MainActivity"
    android:exported="true">

    <!-- existing launcher intent-filter stays as-is -->

    <!-- App Links: https://kindredhome.app/join -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />

        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />

        <data
            android:scheme="https"
            android:host="kindredhome.app"
            android:pathPrefix="/join" />
    </intent-filter>
</activity>
```

Checklist for the common format-check failures:
- [ ] `android:autoVerify="true"` is present on the **App Links** intent-filter.
- [ ] Both `DEFAULT` **and** `BROWSABLE` categories are present.
- [ ] `android:scheme`, `android:host`, and the path attribute live in the
      **same `<data>` element** (splitting host/scheme into separate `<data>`
      tags is the #1 "format" failure).
- [ ] Use `android:pathPrefix="/join"` (covers `/join`, `/join/abc`).
      Use `android:path="/join"` if you want an exact match only.
      Do **not** use a malformed `pathPattern`.
- [ ] The activity is `android:exported="true"` (required on Android 12+).
- [ ] `package_name` in the app == `com.kindredhome.app`.
- [ ] If you also want `http://` to open the app, add a second `<data>` with
      `android:scheme="http"` (the website redirects http→https, so it's
      optional but harmless).
- [ ] If you ever add `www.kindredhome.app`, the website must also serve
      `assetlinks.json` directly (no redirect) at that host.

## Verify before re-submitting

1. **Build-time / static check** of the manifest declarations:
   ```sh
   ./gradlew :app:assembleRelease   # build succeeds with the new filter
   ```
2. **On a device/emulator** (after installing a build):
   ```sh
   # show verification state for your domains
   adb shell pm get-app-links com.kindredhome.app

   # force a re-verify
   adb shell pm verify-app-links --re-verify com.kindredhome.app

   # does tapping the link open the app?
   adb shell am start -a android.intent.action.VIEW \
     -d "https://kindredhome.app/join" com.kindredhome.app
   ```
   You want the domain to show `verified` once the website file is live.
3. **Google's verifier** (the exact service Play uses) — confirms the site half:
   ```
   https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://kindredhome.app&relation=delegate_permission/common.handle_all_urls
   ```
   Should return a statement for `com.kindredhome.app`.

## Ordering / gotchas

- On-device App Links verification **does not follow redirects** — the website
  file must return a direct `200` `application/json` at the apex. That's the
  website team's job; the app can't work around it.
- After fixing the manifest you must **publish a new app version**; existing
  users only route in-app once they update (Play states this on the screen).
- The two website domain errors and your `/join` error are independent — both
  sides must be green for deep links to actually route.

## Pointers back to the website repo

- `kindred-marketing/DEEPLINKS.md` — full runbook for the website/domain side.
- `kindred-marketing/scripts/verify-deeplinks.sh` — one-command live check of
  the hosted `assetlinks.json` (status, content-type, body, Google API).
- `kindred-marketing/public/.well-known/assetlinks.json` — the canonical file.
