#!/usr/bin/env python3
"""Emit Supabase SQL upserts from assets/data/exercises.json.

Usage:
  python3 scripts/generate_exercises_upsert_sql.py > supabase/seed/exercises_upsert.sql
  # Paste/run in Supabase SQL Editor (after migrations/003_exercise_extensions.sql)
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "assets/data/exercises.json"


def esc(s: str) -> str:
    return s.replace("'", "''")


def sql_json(value) -> str:
    return esc(json.dumps(value, ensure_ascii=False))


def main() -> None:
    data = json.loads(JSON_PATH.read_text())
    print("-- Generated from exercises.json — run after 003_exercise_extensions.sql\n")
    for ex in data:
        print(
            f"""INSERT INTO exercises (
  id, name, muscle_groups, equipment, difficulty, estimated_calories,
  form_cues, common_mistakes, is_compound, demo_url, variants, demo_images, demo_source,
  audiences, quick_steps, catalog_tags, demo_frames, demo_video_url, is_deleted
) VALUES (
  '{esc(ex["id"])}',
  '{esc(ex["name"])}',
  '{sql_json(ex.get("muscleGroups", []))}'::jsonb,
  '{sql_json(ex.get("equipment", []))}'::jsonb,
  '{esc(ex["difficulty"])}',
  {int(ex.get("estimatedCalories", 0))},
  '{sql_json(ex.get("formCues", []))}'::jsonb,
  '{sql_json(ex.get("commonMistakes", []))}'::jsonb,
  {str(bool(ex.get("isCompound", False))).upper()},
  {f"'{esc(ex['demoUrl'])}'" if ex.get('demoUrl') else 'NULL'},
  '{sql_json(ex.get("variants", {}))}'::jsonb,
  '{sql_json(ex.get("demoImages", []))}'::jsonb,
  {f"'{esc(ex['demoSource'])}'" if ex.get('demoSource') else 'NULL'},
  '{sql_json(ex.get("audiences", ["all"]))}'::jsonb,
  '{sql_json(ex.get("quickSteps", []))}'::jsonb,
  '{sql_json(ex.get("catalogTags", []))}'::jsonb,
  '{sql_json(ex.get("demoFrames", []))}'::jsonb,
  {f"'{esc(ex['demoVideoUrl'])}'" if ex.get('demoVideoUrl') else 'NULL'},
  false
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  muscle_groups = EXCLUDED.muscle_groups,
  equipment = EXCLUDED.equipment,
  difficulty = EXCLUDED.difficulty,
  estimated_calories = EXCLUDED.estimated_calories,
  form_cues = EXCLUDED.form_cues,
  common_mistakes = EXCLUDED.common_mistakes,
  is_compound = EXCLUDED.is_compound,
  demo_url = EXCLUDED.demo_url,
  variants = EXCLUDED.variants,
  demo_images = EXCLUDED.demo_images,
  demo_source = EXCLUDED.demo_source,
  audiences = EXCLUDED.audiences,
  quick_steps = EXCLUDED.quick_steps,
  catalog_tags = EXCLUDED.catalog_tags,
  demo_frames = EXCLUDED.demo_frames,
  demo_video_url = EXCLUDED.demo_video_url,
  is_deleted = false;
"""
        )
    print(f"-- Total rows: {len(data)}")


if __name__ == "__main__":
    main()