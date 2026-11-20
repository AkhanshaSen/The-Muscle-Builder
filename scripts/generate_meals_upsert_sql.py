#!/usr/bin/env python3
"""Emit Supabase SQL upserts from assets/data/meals.json.

Usage:
  python3 scripts/generate_meals_upsert_sql.py > supabase/seed/meals_upsert.sql
  # Paste/run in Supabase SQL Editor (after supabase/seed/000_run_once_prerequisite_columns.sql)
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "assets/data/meals.json"


def esc(s: str) -> str:
    return s.replace("'", "''")


def sql_json(value) -> str:
    return esc(json.dumps(value, ensure_ascii=False))


def sql_text(value) -> str:
    if value is None:
        return "NULL"
    return f"'{esc(str(value))}'"


def emit_upsert(m: dict) -> str:
    recipe = m.get("recipe")
    recipe_sql = f"'{sql_json(recipe)}'::jsonb" if recipe is not None else "NULL"
    return f"""INSERT INTO meals (
  id, name, description, timing, diet_types, regions, allergens, timing_guidance,
  calories, protein_g, carbs_g, fat_g, portion, recipe, recipe_available,
  ingredient_tags, nutrition_notes, is_deleted, created_at, updated_at
) VALUES (
  '{esc(m["id"])}',
  '{esc(m["name"])}',
  '{esc(m["description"])}',
  '{esc(m["timing"])}',
  '{sql_json(m.get("dietTypes", []))}'::jsonb,
  '{sql_json(m.get("regions", []))}'::jsonb,
  '{sql_json(m.get("allergens", []))}'::jsonb,
  '{esc(m.get("timingGuidance", ""))}',
  {int(m["calories"])},
  {float(m["proteinG"])},
  {float(m["carbsG"])},
  {float(m["fatG"])},
  '{esc(m.get("portion", "1 serving"))}',
  {recipe_sql},
  {str(bool(m.get("recipeAvailable", False))).upper()},
  '{sql_json(m.get("ingredientTags", []))}'::jsonb,
  '{sql_json(m.get("nutritionNotes", []))}'::jsonb,
  false,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  timing = EXCLUDED.timing,
  diet_types = EXCLUDED.diet_types,
  regions = EXCLUDED.regions,
  allergens = EXCLUDED.allergens,
  timing_guidance = EXCLUDED.timing_guidance,
  calories = EXCLUDED.calories,
  protein_g = EXCLUDED.protein_g,
  carbs_g = EXCLUDED.carbs_g,
  fat_g = EXCLUDED.fat_g,
  portion = EXCLUDED.portion,
  recipe = EXCLUDED.recipe,
  recipe_available = EXCLUDED.recipe_available,
  ingredient_tags = EXCLUDED.ingredient_tags,
  nutrition_notes = EXCLUDED.nutrition_notes,
  is_deleted = false,
  updated_at = NOW();
"""


def main() -> None:
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    if isinstance(data, dict):
        data = data.get("meals", [])
    print("-- Meals catalog upsert from meals.json")
    print("-- Prerequisite: supabase/seed/000_run_once_prerequisite_columns.sql\n")
    for meal in data:
        print(emit_upsert(meal))
    print(f"-- Total rows: {len(data)}")


if __name__ == "__main__":
    main()