-- Soft delete + tighten RLS for reference tables
-- Project: https://supabase.com/dashboard/project/kaiffjdbfjkjqisumklh

-- 1. Soft-delete flag on all reference tables
ALTER TABLE meals ADD COLUMN IF NOT EXISTS is_deleted BOOL NOT NULL DEFAULT FALSE;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS is_deleted BOOL NOT NULL DEFAULT FALSE;
ALTER TABLE food_pharmer_pointers ADD COLUMN IF NOT EXISTS is_deleted BOOL NOT NULL DEFAULT FALSE;
ALTER TABLE pro_nutrition_guides ADD COLUMN IF NOT EXISTS is_deleted BOOL NOT NULL DEFAULT FALSE;

-- 2. SELECT policies: only non-deleted rows are visible to clients
DROP POLICY IF EXISTS "public read meals" ON meals;
CREATE POLICY "public read meals" ON meals FOR SELECT USING (is_deleted = false);

DROP POLICY IF EXISTS "public read exercises" ON exercises;
CREATE POLICY "public read exercises" ON exercises FOR SELECT USING (is_deleted = false);

DROP POLICY IF EXISTS "public read food_pharmer_pointers" ON food_pharmer_pointers;
CREATE POLICY "public read food_pharmer_pointers" ON food_pharmer_pointers FOR SELECT USING (is_deleted = false);

DROP POLICY IF EXISTS "public read pro_nutrition_guides" ON pro_nutrition_guides;
CREATE POLICY "public read pro_nutrition_guides" ON pro_nutrition_guides FOR SELECT USING (is_deleted = false);

-- 3. Remove broad anon write policies — reference data is seeded; admin changes
-- via SQL editor / Management API (service role), not the publishable client key.
DROP POLICY IF EXISTS "public insert meals" ON meals;
DROP POLICY IF EXISTS "public update meals" ON meals;

DROP POLICY IF EXISTS "public insert exercises" ON exercises;
DROP POLICY IF EXISTS "public update exercises" ON exercises;

DROP POLICY IF EXISTS "public insert food_pharmer_pointers" ON food_pharmer_pointers;
DROP POLICY IF EXISTS "public update food_pharmer_pointers" ON food_pharmer_pointers;
DROP POLICY IF EXISTS "public delete food_pharmer_pointers" ON food_pharmer_pointers;

DROP POLICY IF EXISTS "public insert pro_nutrition_guides" ON pro_nutrition_guides;
DROP POLICY IF EXISTS "public update pro_nutrition_guides" ON pro_nutrition_guides;
