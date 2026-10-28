-- Reference data tables for The Muscle Builder
-- Run in Supabase SQL Editor: https://supabase.com/dashboard/project/kaiffjdbfjkjqisumklh/sql

-- meals
CREATE TABLE IF NOT EXISTS meals (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  timing TEXT NOT NULL,
  diet_types JSONB NOT NULL DEFAULT '[]',
  regions JSONB NOT NULL DEFAULT '[]',
  allergens JSONB NOT NULL DEFAULT '[]',
  timing_guidance TEXT NOT NULL,
  calories INT NOT NULL,
  protein_g FLOAT NOT NULL,
  carbs_g FLOAT NOT NULL,
  fat_g FLOAT NOT NULL,
  portion TEXT NOT NULL,
  recipe JSONB,
  recipe_available BOOL DEFAULT FALSE,
  ingredient_tags JSONB DEFAULT '[]',
  nutrition_notes JSONB DEFAULT '[]'
);

-- exercises
CREATE TABLE IF NOT EXISTS exercises (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  muscle_groups JSONB NOT NULL DEFAULT '[]',
  equipment JSONB NOT NULL DEFAULT '[]',
  difficulty TEXT NOT NULL,
  estimated_calories INT NOT NULL,
  form_cues JSONB NOT NULL DEFAULT '[]',
  common_mistakes JSONB NOT NULL DEFAULT '[]',
  is_compound BOOL DEFAULT FALSE,
  demo_url TEXT,
  variants JSONB NOT NULL DEFAULT '{}',
  demo_images JSONB DEFAULT '[]',
  demo_source TEXT
);

-- food pharmer pointers
CREATE TABLE IF NOT EXISTS food_pharmer_pointers (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  tip TEXT NOT NULL,
  url TEXT NOT NULL
);

-- pro nutrition guides
CREATE TABLE IF NOT EXISTS pro_nutrition_guides (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  source TEXT NOT NULL,
  benefit TEXT NOT NULL,
  url TEXT NOT NULL
);

-- RLS: public read for anon (no auth yet)
ALTER TABLE meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE food_pharmer_pointers ENABLE ROW LEVEL SECURITY;
ALTER TABLE pro_nutrition_guides ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public read meals" ON meals;
CREATE POLICY "public read meals" ON meals FOR SELECT USING (true);

DROP POLICY IF EXISTS "public read exercises" ON exercises;
CREATE POLICY "public read exercises" ON exercises FOR SELECT USING (true);

DROP POLICY IF EXISTS "public read food_pharmer_pointers" ON food_pharmer_pointers;
CREATE POLICY "public read food_pharmer_pointers" ON food_pharmer_pointers FOR SELECT USING (true);

DROP POLICY IF EXISTS "public read pro_nutrition_guides" ON pro_nutrition_guides;
CREATE POLICY "public read pro_nutrition_guides" ON pro_nutrition_guides FOR SELECT USING (true);

-- Allow anon upsert so the one-time in-app seeder can populate empty tables.
-- Tighten these once auth / a proper seed pipeline exists.
DROP POLICY IF EXISTS "public insert meals" ON meals;
CREATE POLICY "public insert meals" ON meals FOR INSERT WITH CHECK (true);
DROP POLICY IF EXISTS "public update meals" ON meals;
CREATE POLICY "public update meals" ON meals FOR UPDATE USING (true);

DROP POLICY IF EXISTS "public insert exercises" ON exercises;
CREATE POLICY "public insert exercises" ON exercises FOR INSERT WITH CHECK (true);
DROP POLICY IF EXISTS "public update exercises" ON exercises;
CREATE POLICY "public update exercises" ON exercises FOR UPDATE USING (true);

DROP POLICY IF EXISTS "public insert food_pharmer_pointers" ON food_pharmer_pointers;
CREATE POLICY "public insert food_pharmer_pointers" ON food_pharmer_pointers FOR INSERT WITH CHECK (true);
DROP POLICY IF EXISTS "public update food_pharmer_pointers" ON food_pharmer_pointers;
CREATE POLICY "public update food_pharmer_pointers" ON food_pharmer_pointers FOR UPDATE USING (true);

DROP POLICY IF EXISTS "public insert pro_nutrition_guides" ON pro_nutrition_guides;
CREATE POLICY "public insert pro_nutrition_guides" ON pro_nutrition_guides FOR INSERT WITH CHECK (true);
DROP POLICY IF EXISTS "public update pro_nutrition_guides" ON pro_nutrition_guides;
CREATE POLICY "public update pro_nutrition_guides" ON pro_nutrition_guides FOR UPDATE USING (true);

-- Optional deletes for admin cleanup of reference rows (tighten once auth lands).
DROP POLICY IF EXISTS "public delete food_pharmer_pointers" ON food_pharmer_pointers;
CREATE POLICY "public delete food_pharmer_pointers" ON food_pharmer_pointers FOR DELETE USING (true);
