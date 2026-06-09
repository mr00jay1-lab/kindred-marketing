# Kindred — Privacy Policy

**Effective date:** 25 April 2026
**Last updated:** 25 April 2026
**Data controller:** Jay Tanna, 15 Eagles Heath, Bedford, MK42 7NN.
**Contact:** support@kindredhome.app

> ⚠️ **Owner: this is a starter draft, not legal advice.** It covers the App Store / Play Store / UK GDPR basics so you can publish a URL during phase 4 development. Have a solicitor review it before phase 10 public release.

---

## 1. Who we are

Kindred is a household management app made by Jay Tanna. We help families plan meals, share shopping lists, divide chores, and store household recipes. This policy explains what data Kindred collects, why, and what control you have over it.

If you contact us about this policy, write to support@kindredhome.app.

## 2. What data we collect

### 2.1 Account information
When you sign in, we collect:
- **Email address** (required for account recovery and verification).
- **Display name** and **profile photo URL** (if you sign in with Apple or Google, these come from those services).
- **Authentication provider** (Email / Apple / Google).

If you choose Sign in with Apple's "Hide my email" option, we only ever see Apple's relay address and never your real email.

### 2.2 Household content
When you use Kindred, you and your household members create:
- Household name, timezone, and member roles (admin, adult, child, read-only).
- Meal plans, recipes, shopping lists, chores, and notes.
- Photos you upload — recipe images, receipts, profile avatars.

This content is stored in your private household database and is only visible to members of that household.

### 2.3 AI feature usage (Premium and Max tiers)
If you use AI recipe import or AI meal planning:
- The recipe URL or photo you submit is sent to our AI provider (Anthropic) for parsing.
- The recipe text returned is stored in your household.
- We do not retain your submission after the parse completes.
- **Max tier with BYOK (Bring Your Own Key):** if you provide your own Anthropic API key, it is stored in your device's secure storage (iOS Keychain / Android Keystore) and never sent to our servers.

### 2.4 Subscription and payment information
- **Apple App Store** or **Google Play** processes your payment. We never see your card details.
- Our subscription provider (RevenueCat) receives an anonymous "App User ID" and your subscription status (e.g. "Premium, renews 1 May").
- We use this only to unlock paid features in the app.

### 2.5 Device and diagnostic data
- **Push notification tokens** (so we can send you reminders — only if you grant permission).
- **Anonymous crash reports** via Firebase Crashlytics (so we can diagnose bugs).
- **App usage metrics** via Firebase Analytics — aggregate counts only, no personal identifiers.

You can opt out of analytics and crash reporting in Kindred → Settings → Privacy.

### 2.6 What we do NOT collect
- Your contacts, calendar, photos library (unless you explicitly upload a photo).
- Your location.
- Your microphone or camera (camera only when you tap "take a photo" inside the app).
- Web browsing history.
- Any biometric data.

## 3. Why we use your data

| Purpose | Legal basis (UK GDPR) |
|---|---|
| Provide the core app (sign-in, household sync, meal plans) | Contract — Article 6(1)(b) |
| Send transactional emails (verification, password reset) | Contract — Article 6(1)(b) |
| Process subscription payments | Contract — Article 6(1)(b) |
| Send push notifications you opted into | Consent — Article 6(1)(a) |
| Diagnose bugs and improve the app (anonymous crash + usage data) | Legitimate interests — Article 6(1)(f) |
| Detect and prevent abuse (e.g. fraud, spam) | Legitimate interests — Article 6(1)(f) |
| Comply with legal obligations (tax records, court orders) | Legal obligation — Article 6(1)(c) |

We do **not** sell your data, share it with advertisers, or use it for advertising profiles.

## 4. Who we share data with

Kindred uses third-party services to operate. Each only receives the minimum data needed for its function.

| Provider | Purpose | Data shared | Where they process it |
|---|---|---|---|
| Google Firebase | Auth, database, file storage, hosting, push notifications | Account info, household content, photos, push tokens | europe-west2 (London, UK) |
| Anthropic (Claude) | AI recipe + meal-plan features | The single recipe URL or photo you submit | United States |
| RevenueCat | Subscription management | Anonymous App User ID, purchase status | United States |
| Apple App Store | iOS payments | Card data (we never see it) | Per Apple's policy |
| Google Play Store | Android payments | Card data (we never see it) | Per Google's policy |
| Apple Sign in with Apple | Optional sign-in method | Email (or relay), name | Per Apple's policy |
| Google Sign-In | Optional sign-in method | Email, name, photo URL | Per Google's policy |

For international transfers (e.g. Anthropic in the US), we rely on the UK International Data Transfer Agreement and the EU Standard Contractual Clauses where applicable.

We do **not** share your data with any other third parties unless required by law (e.g. a court order).

## 5. How long we keep your data

- **Active accounts:** for as long as your account exists.
- **Deleted accounts:** when you tap "Delete my account" in Settings, your account and all your personal data are removed within 30 days. Household content you authored may be retained if other household members still use it, but it is dissociated from you.
- **Backups:** automatic backups are retained for up to 30 days for disaster recovery.
- **Subscription records:** retained for 7 years for tax and accounting.
- **Anonymous diagnostic data:** retained for up to 14 months.

## 6. Your rights

Under UK GDPR (and equivalent under California's CCPA, EU GDPR, etc.) you have the right to:

- **Access** the personal data we hold about you. Use Settings → Privacy → "Export my data" — Kindred generates a JSON file you can download.
- **Correct** inaccurate data. Most data is editable directly in the app.
- **Delete** your account and personal data. Use Settings → Account → "Delete my account".
- **Restrict or object** to certain processing.
- **Portability** — the JSON export above is in a machine-readable format.
- **Withdraw consent** for any consent-based processing (e.g. push notifications) at any time, in Settings.
- **Complain** to a data protection authority. In the UK that's the Information Commissioner's Office (<https://ico.org.uk>). In the EU, your local DPA.

We respond to rights requests within **30 days**. Email legal@kindredhome.app to make a request.

## 7. Children

Kindred is **not directed at children under 13** (under 16 in some EU jurisdictions). Adults can add a "child" role for a family member so the child can tick off chores or view meal plans, but this role exists for in-app access control — we do not knowingly collect personal data from children directly.

If you believe a child has created an account without parental consent, email legal@kindredhome.app and we will delete the account.

## 8. Security

We protect your data with:
- TLS encryption in transit (HTTPS everywhere).
- Encryption at rest in Google Firebase.
- Role-based access controls — only members of your household can read your household's data.
- Regular security reviews of our database access rules.

No system is perfectly secure. If we discover a breach affecting your data, we will notify you and the relevant data protection authority within 72 hours, as required by UK GDPR.

## 9. Cookies and similar technologies

The Kindred mobile apps do not use cookies. They do store authentication tokens locally on your device so you don't have to sign in every time.

Kindred does not currently offer a web preview. If we publish one in future, a small number of strictly necessary cookies and local-storage entries will be used for sign-in only, and this policy will be updated to list the URL. We do not use advertising or analytics cookies on the web.

## 10. Changes to this policy

We will update this policy when we add features that change what data we collect. The "Effective date" at the top will reflect the most recent change. Material changes will be notified in-app at least 14 days before they take effect.

## 11. Contact

Questions, requests, or complaints? Write to:

Jay Tanna
15 Eagles Heath, Bedford, MK42 7NN
Email: support@kindredhome.app (general) · legal@kindredhome.app (data-protection / GDPR rights requests)

---

*This policy was generated as a starter draft for Kindred phase 4 development. Review by qualified legal counsel before public app store release.*
