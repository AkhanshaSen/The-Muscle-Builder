#!/usr/bin/env python3
"""Emit Supabase SQL upserts from assets/data/exercises.json.

Usage:
  python3 scripts/generate_exercises_upsert_sql.py > supabase/seed/exercises_upsert.sql
  python3 scripts/generate_exercises_upsert_sql.py --filter new --base-ref 'f66cc14^' \\
    > supabase/seed/004_exercises_new_inserts.sql
  python3 scripts/generate_exercises_upsert_sql.py --filter updated --base-ref 'f66cc14^' \\
    > supabase/seed/005_exercises_catalog_field_updates.sql
  # Paste/run in Supabase SQL Editor (after migrations/003_exercise_extensions.sql)
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "assets/data/exercises.json"


def esc(s: str) -> str:
    return s.replace("'", "''")


def sql_json(value) -> str:
    return esc(json.dumps(value, ensure_ascii=False))


def load_exercises(path: Path) -> list[dict]:
    data = json.loads(path.read_text(encoding="utf-8"))
    if isinstance(data, dict):
        data = data.get("exercises", [])
    return data


def load_exercises_git(ref: str) -> list[dict]:
    proc = subprocess.run(
        ["git", "show", f"{ref}:assets/data/exercises.json"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        sys.exit(
            f"Could not read exercises at git ref {ref!r}: {proc.stderr.strip() or proc.stdout}"
        )
    data = json.loads(proc.stdout)
    if isinstance(data, dict):
        data = data.get("exercises", [])
    return data


def filter_exercises(
    exercises: list[dict],
    mode: str,
    base_ref: str | None,
) -> list[dict]:
    if mode == "all":
        return exercises
    if not base_ref:
        sys.exit("--base-ref is required when --filter is not 'all'")
    old = {ex["id"] for ex in load_exercises_git(base_ref)}
    current_ids = {ex["id"] for ex in exercises}
    if mode == "new":
        return [ex for ex in exercises if ex["id"] not in old]
    if mode == "updated":
        return [
            ex
            for ex in exercises
            if ex["id"] in old
            and json.dumps(ex, sort_keys=True)
            != json.dumps(
                next(e for e in load_exercises_git(base_ref) if e["id"] == ex["id"]),
                sort_keys=True,
            )
        ]
    sys.exit(f"Unknown filter mode: {mode}")


def emit_upsert(ex: dict) -> str:
    return f"""INSERT INTO exercises (
  id, name, muscle_groups, equipment, difficulty, estimated_calories,
  form_cues, common_mistakes, is_compound, demo_url, variants, demo_images, demo_source,
  audiences, quick_steps, catalog_tags, demo_frames, demo_video_url, is_deleted,
  created_at, updated_at
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
  false,
  NOW(),
  NOW()
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
  is_deleted = false,
  updated_at = NOW();
"""


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--filter",
        choices=("all", "new", "updated"),
        default="all",
        help="Which rows to emit (default: all exercises in JSON)",
    )
    parser.add_argument(
        "--base-ref",
        default=None,
        help="Git ref for the previous exercises.json (e.g. 'f66cc14^' or a commit SHA)",
    )
    parser.add_argument(
        "--title",
        default=None,
        help="Optional first-line SQL comment title",
    )
    args = parser.parse_args()

    exercises = load_exercises(JSON_PATH)
    rows = filter_exercises(exercises, args.filter, args.base_ref)

    title = args.title or f"exercises.json ({args.filter}, {len(rows)} rows)"
    print(f"-- {title}")
    print(
        "-- Prerequisite: run supabase/seed/000_run_once_prerequisite_columns.sql once.\n"
    )
    for ex in rows:
        print(emit_upsert(ex))
    print(f"-- Total rows: {len(rows)}")


if __name__ == "__main__":
    main()