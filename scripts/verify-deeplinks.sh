#!/usr/bin/env bash
#
# verify-deeplinks.sh — run every check Google's Digital Asset Links verifier
# runs against the live site, so we know BEFORE clicking "Re-verify" in the
# Play Console whether the two domain errors are actually cleared.
#
# Errors this maps to in Play Console → Deep links → kindredhome.app:
#   * "Digital Asset Links JSON file failed"  -> reachability / redirect / 404
#   * "JSON content type failed"              -> Content-Type must be application/json
#
# Usage:
#   ./scripts/verify-deeplinks.sh                 # checks https://kindredhome.app
#   ./scripts/verify-deeplinks.sh example.com     # override the host
#
# Exit 0 only if the apex serves the file with a direct 200 + JSON content-type
# AND the body matches the expected package + a 64-hex SHA-256.
#
# NOTE: requires outbound network access to the host. In the sandboxed Claude
# environment the apex is behind the egress allowlist; run this once that host
# (or "production") is allowed.

set -uo pipefail

HOST="${1:-kindredhome.app}"
PKG="com.kindredhome.app"
URL="https://${HOST}/.well-known/assetlinks.json"

red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
yellow(){ printf '\033[33m%s\033[0m\n' "$*"; }

fail=0

echo "== Digital Asset Links verification for ${HOST} =="
echo "URL: ${URL}"
echo

# 1) Direct fetch WITHOUT following redirects — on-device App Links verification
#    does NOT follow redirects, so a 3xx here is a real failure.
echo "1) Direct fetch (no redirect follow)"
code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 "${URL}")
ctype=$(curl -sI --max-time 20 "${URL}" | tr -d '\r' | awk -F': ' 'tolower($1)=="content-type"{print tolower($2)}')
echo "   HTTP status   : ${code}"
echo "   Content-Type  : ${ctype:-<none>}"

case "$code" in
  200) green "   ✓ 200 OK (no redirect)";;
  30*) red   "   ✗ redirect (${code}) — App Links does NOT follow redirects. Serve the file directly at the apex."; fail=1;;
  404) red   "   ✗ 404 — file not live at this host. Confirm THIS repo's GitHub Pages deploy owns the apex (not Cloudflare/kindred-legal)."; fail=1;;
  000) red   "   ✗ no response — DNS/egress/host unreachable."; fail=1;;
  *)   red   "   ✗ unexpected status ${code}"; fail=1;;
esac

case "$ctype" in
  application/json*) green "   ✓ Content-Type is application/json";;
  "")                red "   ✗ no Content-Type header"; fail=1;;
  *html*)            red "   ✗ Content-Type is '${ctype}' — you're hitting the HTML 404/redirect page, not the JSON file."; fail=1;;
  *)                 red "   ✗ Content-Type is '${ctype}', must be application/json"; fail=1;;
esac
echo

# 2) Body validity — must parse as JSON, contain the package, and a 64-hex fp.
echo "2) Body validity"
body_file="$(mktemp)"
trap 'rm -f "$body_file"' EXIT
curl -sL --max-time 20 "${URL}" -o "$body_file"
if command -v node >/dev/null 2>&1; then
  node - "$PKG" "$body_file" <<'NODE' || fail=1
const pkg = process.argv[2];
let raw = require('fs').readFileSync(process.argv[3], 'utf8');
try {
  const d = JSON.parse(raw);
  const stmt = (Array.isArray(d) ? d : []).find(s => s?.target?.package_name === pkg);
  if (!stmt) { console.error(`   ✗ no statement for package ${pkg}`); process.exit(1); }
  const fps = stmt.target.sha256_cert_fingerprints || [];
  const ok = fps.some(f => f.replace(/:/g, '').length === 64 && /^[0-9A-Fa-f]+$/.test(f.replace(/:/g, '')));
  if (!ok) { console.error('   ✗ no valid 64-hex SHA-256 fingerprint'); process.exit(1); }
  console.log(`   ✓ valid JSON, package ${pkg}, ${fps.length} fingerprint(s)`);
} catch (e) {
  console.error('   ✗ body is not valid JSON (you are probably getting an HTML page):');
  console.error('     ' + raw.slice(0, 120).replace(/\n/g, ' '));
  process.exit(1);
}
NODE
else
  yellow "   ! node not found — skipping JSON body validation"
fi
echo

# 3) Cross-check against Google's own verifier (the exact service Play uses).
echo "3) Google Digital Asset Links API (the service Play actually queries)"
gapi="https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://${HOST}&relation=delegate_permission/common.handle_all_urls"
gout=$(curl -sL --max-time 25 "$gapi")
if echo "$gout" | grep -q "$PKG"; then
  green "   ✓ Google's API returns a statement for ${PKG}"
else
  red   "   ✗ Google's API does not return ${PKG} for ${HOST}"
  echo  "     response: $(echo "$gout" | tr -d '\n' | cut -c1-200)"
  fail=1
fi
echo

if [ "$fail" -eq 0 ]; then
  green "ALL CHECKS PASSED — go to Play Console → Deep links → ${HOST} → 'Re-verify'."
  exit 0
else
  red "ONE OR MORE CHECKS FAILED — fix the above before re-verifying in Play Console."
  exit 1
fi
