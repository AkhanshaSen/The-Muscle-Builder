-- Extend exercises reference table for app catalog fields (v88+ JSON).
-- Run in Supabase SQL Editor before bulk upsert from scripts/generate_exercises_upsert_sql.py

ALTER TABLE exercises
  ADD COLUMN IF NOT EXISTS audiences JSONB DEFAULT '["all"]',
  ADD COLUMN IF NOT EXISTS quick_steps JSONB DEFAULT '[]',
  ADD COLUMN IF NOT EXISTS catalog_tags JSONB DEFAULT '[]',
  ADD COLUMN IF NOT EXISTS demo_frames JSONB DEFAULT '[]',
  ADD COLUMN IF NOT EXISTS demo_video_url TEXT;