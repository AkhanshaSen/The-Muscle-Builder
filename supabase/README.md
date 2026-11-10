# Supabase reference data

Project: [`kaiffjdbfjkjqisumklh`](https://supabase.com/dashboard/project/kaiffjdbfjkjqisumklh)

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
```

Client (publishable key) is **SELECT-only**. Writes use the dashboard / CLI.

See also [docs/SECURITY.md](../docs/SECURITY.md).
