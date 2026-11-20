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
2. `SeedRepository` / `GuidesRepository` fetch from Supabase first, then fall back to bundled assets / const lists.
3. Client seeding from the app is **disabled** — anon INSERT policies are closed. Seed from SQL editor / Management API instead.

## Soft delete

All four tables have `is_deleted BOOL NOT NULL DEFAULT FALSE`. Soft-deleted
rows are hidden by RLS (`SELECT … USING (is_deleted = false)`). Mark a row
deleted via service role (SQL editor / Management API), not from the app:

```sql
UPDATE meals SET is_deleted = true WHERE id = 'some_id';
```

## Migrations

```bash
# Initial tables + (legacy) open write policies:
supabase/migrations/001_reference_tables.sql
# Soft delete + read-only client policies:
supabase/migrations/002_is_deleted_and_security.sql
# Exercise catalog columns (audiences, quick_steps, demo_frames, etc.):
supabase/migrations/003_exercise_extensions.sql
```

## Refreshing exercises after JSON changes

The in-app catalog reads Supabase when `SUPABASE_ANON_KEY` is set. Bundled `assets/data/exercises.json` is the source of truth for generation.

1. Run `003_exercise_extensions.sql` in the SQL editor if not applied yet.
2. Generate upsert SQL:
   ```bash
   python3 scripts/generate_exercises_upsert_sql.py > supabase/seed/exercises_upsert.sql
   ```
3. Paste and run `exercises_upsert.sql` in the dashboard (service role / SQL editor), **or** from the project root:
   ```bash
   # .env.local: SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY (see .env.example)
   python3 scripts/upsert_reference_data.py
   # exercises only:
   python3 scripts/upsert_reference_data.py --tables exercises
   ```
4. Restart the app with `--dart-define=SUPABASE_ANON_KEY=...`.

Client (publishable key) is **SELECT-only**. Writes use the dashboard / CLI or `scripts/upsert_reference_data.py` with the **service_role** key in `.env.local`.

See also [docs/SECURITY.md](../docs/SECURITY.md).
