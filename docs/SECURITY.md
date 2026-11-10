# Security (personal / small-scale)

Right-sized for a single-user Flutter app: local Drift for personal data, Supabase only for shared reference content (meals, exercises, guides).

## What lives where

| Data | Where | Access |
| --- | --- | --- |
| Profile, workouts, check-ins, metrics | Local Drift SQLite | Device only |
| Meals, exercises, Food Pharmer, guides | Supabase (read-only) | Publishable key + RLS |

## Keys and secrets

- **Never** commit `.env`, service_role keys, or signing keystores.
- Publishable / anon key is passed at build time (replace `XXXX` with your key locally):

```bash
flutter run --dart-define=SUPABASE_ANON_KEY=XXXX
flutter build apk --release --dart-define=SUPABASE_ANON_KEY=XXXX
```

- Without the key, the app uses bundled `assets/data/*.json` and Dart const lists.
- CI: set repository secret `SUPABASE_ANON_KEY` (see `.github/workflows/mobile-builds.yml`).
- Template: [`.env.example`](../.env.example) (documentation only; Flutter does not auto-load `.env`).

## Supabase RLS (reference tables)

- Tables: `meals`, `exercises`, `food_pharmer_pointers`, `pro_nutrition_guides`
- Client can **SELECT** rows where `is_deleted = false` only
- No anon INSERT / UPDATE / DELETE — seed or edit via SQL editor / Management API (service role)
- Soft-delete: `UPDATE … SET is_deleted = true WHERE id = '…'`

## HTTPS / database exposure

- All Supabase traffic is HTTPS
- Postgres is not exposed on a public port; use the dashboard / pooler with credentials

## Logging and errors

- `AppLog` is debug-only (`kDebugMode`)
- UI uses `userSafeError()` — generic copy in release builds

## Forms

- Name / journey / story fields are trimmed and length-capped (`AppConstants.max*Length`)

## Deferred until cloud sync / accounts

| Checklist item | Why deferred |
| --- | --- |
| Login / sessions / password hashing | No accounts yet; add Supabase Auth when syncing |
| Login rate limits | Built into Supabase Auth |
| Users see only their data (server RLS) | No user rows in Postgres yet |
| Admin RBAC in-app | Supabase dashboard is admin |

## Dashboard chores (free tier)

1. Confirm project backups are enabled in Supabase
2. Never paste `service_role` into the Flutter app
3. **Rotate the publishable key** in Supabase → Settings → API if it was ever committed to git history, then update GitHub secret `SUPABASE_ANON_KEY` and local `--dart-define`

## GitHub APK trust signals

CI ([`.github/workflows/mobile-builds.yml`](../.github/workflows/mobile-builds.yml)) on each Android build:

1. **`dart analyze --fatal-warnings`** and **`flutter test`** — no APK if either fails
2. **`apksigner verify`** — confirms the APK signature; cert SHA-256 is written to the release notes
3. **SHA256 checksums** — `CHECKSUMS-SHA256.txt` uploaded with the APK; hash also in the [Latest build](https://github.com/AkhanshaSen/The-Muscle-Builder/releases/tag/latest) body
4. **VirusTotal** (optional) — when repository secret `VIRUSTOTAL_API_KEY` is set, CI uploads the APK and links the report; the job **fails** if any vendor reports `malicious`

VirusTotal is a **best-effort** signal, not a legal guarantee. Free-tier API keys have daily quotas; if upload/analysis times out, CI still publishes a file-hash URL for later lookup. Re-scan happens on every new build.

### Safe sideload checklist

1. Download only from this repo’s Actions artifacts or the Latest build release
2. Verify `shasum -a 256` / `sha256sum` / `Get-FileHash` matches the release notes
3. Expect Play Protect / “unknown app” for sideloading — normal, not malware proof
4. Compare the CI VirusTotal link (or upload manually at [virustotal.com](https://www.virustotal.com/))
5. Permissions: `INTERNET` only in the release manifest (plus Flutter `PROCESS_TEXT` query)

Debug-signed APKs (no `ANDROID_KEYSTORE_*` secrets) are labeled in release notes as **not for distribution**.

## Pre-release checklist

```bash
flutter pub outdated
dart analyze
flutter test
flutter build apk --release --dart-define=SUPABASE_ANON_KEY=XXXX
```

Smoke-test: onboarding → home → nutrition (meals load) → workout check-in.
