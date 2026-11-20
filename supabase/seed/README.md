# Reference data seed SQL (Supabase SQL Editor)

| Source JSON | Rows | SQL file |
| --- | --- | --- |
| `assets/data/exercises.json` | 88 | `exercises_upsert_full.sql` |
| `assets/data/meals.json` | 58 | `meals_upsert.sql` |

## Run order (fresh or full refresh)

1. **`000_run_once_prerequisite_columns.sql`** — exercise v88 columns + `created_at` / `updated_at` on reference tables (or run migrations `003` + `004_reference_timestamps.sql`).
2. **`meals_upsert.sql`** — full meal catalog.
3. **`exercises_upsert_full.sql`** — full exercise catalog.

Each statement is `INSERT … ON CONFLICT (id) DO UPDATE` (safe to re-run).

## Verify

```sql
SELECT count(*) FROM meals WHERE is_deleted = false;      -- expect 58
SELECT count(*) FROM exercises WHERE is_deleted = false;  -- expect 88
```

## Incremental exercise updates (optional)

If you already have 50 legacy rows and only need deltas:

- `004_exercises_new_inserts.sql` — 38 new IDs
- `005_exercises_catalog_field_updates.sql` — refresh existing 50

## Regenerate

```bash
python3 scripts/generate_meals_upsert_sql.py > supabase/seed/meals_upsert.sql
python3 scripts/generate_exercises_upsert_sql.py > supabase/seed/exercises_upsert_full.sql
```

Alternative: `python3 scripts/upsert_reference_data.py --tables meals,exercises` with service role in `.env.local`.

Use the SQL editor with **dashboard admin** / service role (anon client cannot write after migration 002).