-- Audit timestamps on reference tables (run once in SQL Editor).

ALTER TABLE meals
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE exercises
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE food_pharmer_pointers
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE pro_nutrition_guides
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Backfill any legacy rows (no-op when DEFAULT already applied).
UPDATE meals SET created_at = NOW(), updated_at = NOW()
  WHERE created_at IS NULL OR updated_at IS NULL;
UPDATE exercises SET created_at = NOW(), updated_at = NOW()
  WHERE created_at IS NULL OR updated_at IS NULL;
UPDATE food_pharmer_pointers SET created_at = NOW(), updated_at = NOW()
  WHERE created_at IS NULL OR updated_at IS NULL;
UPDATE pro_nutrition_guides SET created_at = NOW(), updated_at = NOW()
  WHERE created_at IS NULL OR updated_at IS NULL;