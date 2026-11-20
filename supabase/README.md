# Supabase reference data

Project: [Supabase dashboard](https://supabase.com/dashboard/project/YOUR_PROJECT_REF)

## Tables

| Table | Source |
| --- | --- |
| `meals` | `assets/data/meals.json` |
| `exercises` | `assets/data/exercises.json` |
| `food_pharmer_pointers` | `lib/data/seed/pro_nutrition_guides.dart` |
| `pro_nutrition_guides` | same file |

## App behaviour

1. `main.dart` initializes Supabase only when `SUPABASE_ANON_KEY` is passed via `--dart-define`.
2. **`SeedRepository`** (meals + exercises): loads **only from Supabase** when the key is set; bundled JSON is used **only** when the key is missing (CI/tests).
3. **`GuidesRepository`**: Supabase first, then Dart const fallbacks.
4. Client seeding from the app is **disabled** — anon INSERT policies are closed. Seed from SQL editor / `scripts/upsert_reference_data.py` (service role).

## Soft delete

All four tables have `is_deleted BOOL NOT NULL DEFAULT FALSE`. Soft-deleted
rows are hidden by RLS (`SELECT … USING (is_deleted = false)`). Mark a row
deleted via service role (SQL editor / Management API), not from the app:

```sql
UPDATE meals SET is_deleted = true, updated_at = now() WHERE id = 'some_id';
-- Restore: SET is_deleted = false, updated_at = now()
```

Re-running generated upserts updates catalog fields but **does not** reset
`is_deleted` on existing rows (`ON CONFLICT` omits that column). The app
refetches on resume / Nutrition pull-to-refresh when the anon key is set.

## Migrations

```bash
# Initial tables + (legacy) open write policies:
supabase/migrations/001_reference_tables.sql
# Soft delete + read-only client policies:
supabase/migrations/002_is_deleted_and_security.sql
# Exercise catalog columns (audiences, quick_steps, demo_frames, etc.):
supabase/migrations/003_exercise_extensions.sql
# created_at / updated_at on reference tables:
supabase/migrations/004_reference_timestamps.sql
```

## Refreshing meals and exercises after JSON changes

JSON under `assets/data/` is the **generation source**; runtime uses Supabase when `SUPABASE_ANON_KEY` is set.

1. Run prerequisites: `000_run_once_prerequisite_columns.sql` or migrations `003` + `004` (see [`supabase/seed/README.md`](seed/README.md)).
2. Full catalogs (recommended): **`meals_upsert.sql`** (58) + **`exercises_upsert_full.sql`** (88).
3. Regenerate:
   ```bash
   python3 scripts/generate_meals_upsert_sql.py > supabase/seed/meals_upsert.sql
   python3 scripts/generate_exercises_upsert_sql.py > supabase/seed/exercises_upsert_full.sql
   ```
4. Paste and run the SQL in the dashboard, **or** from the project root:
   ```bash
   # .env.local: SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY (see .env.example)
   python3 scripts/upsert_reference_data.py
   # exercises only:
   python3 scripts/upsert_reference_data.py --tables exercises
   ```
4. Restart the app with `--dart-define=SUPABASE_ANON_KEY=...`.

Client (publishable key) is **SELECT-only**. Writes use the dashboard / CLI or `scripts/upsert_reference_data.py` with the **service_role** key in `.env.local`.

See also [docs/SECURITY.md](../docs/SECURITY.md).
