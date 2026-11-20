#!/usr/bin/env python3
"""Upsert bundled reference data into Supabase using credentials from .env.local.

Required in .env.local (project root; see .env.example):
  SUPABASE_URL=https://....supabase.co
  SUPABASE_SERVICE_ROLE_KEY=...   # Dashboard → API → service_role (never ship in the app)

Optional:
  SUPABASE_ANON_KEY=...           # used only if service role is missing (usually fails after migration 002)
  DATABASE_URL=...                # if set, applies migration 003 via psql before upsert

Usage:
  python3 scripts/upsert_reference_data.py
  python3 scripts/upsert_reference_data.py --tables exercises
  python3 scripts/upsert_reference_data.py --dry-run
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MEALS_JSON = ROOT / "assets/data/meals.json"
EXERCISES_JSON = ROOT / "assets/data/exercises.json"
GUIDES_DART = ROOT / "lib/data/seed/pro_nutrition_guides.dart"
MIGRATION_003 = ROOT / "supabase/migrations/003_exercise_extensions.sql"
DEFAULT_URL = "https://kaiffjdbfjkjqisumklh.supabase.co"


def load_env_local(extra: Path | None = None) -> dict[str, str]:
    out: dict[str, str] = {}
    paths: list[Path] = []
    if extra is not None:
        paths.append(extra)
    paths.extend(ROOT / name for name in (".env.local", ".env"))
    for path in paths:
        if not path.is_file():
            continue
        for line in path.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, val = line.split("=", 1)
            out[key.strip()] = val.strip().strip('"').strip("'")
    return out


def normalize_env(raw: dict[str, str]) -> dict[str, str]:
    """Accept SUPABASE_* or NEXT_PUBLIC_SUPABASE_* from .env.local."""
    env = dict(raw)
    if not env.get("SUPABASE_URL", "").strip():
        env["SUPABASE_URL"] = env.get("NEXT_PUBLIC_SUPABASE_URL", "").strip()
    if not env.get("SUPABASE_ANON_KEY", "").strip():
        env["SUPABASE_ANON_KEY"] = env.get(
            "NEXT_PUBLIC_SUPABASE_ANON_KEY", ""
        ).strip()
    return env


def exercise_row(ex: dict) -> dict:
    return {
        "id": ex["id"],
        "name": ex["name"],
        "muscle_groups": ex.get("muscleGroups", []),
        "equipment": ex.get("equipment", []),
        "difficulty": ex["difficulty"],
        "estimated_calories": ex.get("estimatedCalories", 0),
        "form_cues": ex.get("formCues", []),
        "common_mistakes": ex.get("commonMistakes", []),
        "is_compound": ex.get("isCompound", False),
        "demo_url": ex.get("demoUrl"),
        "variants": ex.get("variants", {}),
        "demo_images": ex.get("demoImages", []),
        "demo_source": ex.get("demoSource"),
        "audiences": ex.get("audiences", ["all"]),
        "quick_steps": ex.get("quickSteps", []),
        "catalog_tags": ex.get("catalogTags", []),
        "demo_frames": ex.get("demoFrames", []),
        "demo_video_url": ex.get("demoVideoUrl"),
    }


def meal_row(m: dict) -> dict:
    return {
        "id": m["id"],
        "name": m["name"],
        "description": m["description"],
        "timing": m["timing"],
        "diet_types": m.get("dietTypes", []),
        "regions": m.get("regions", []),
        "allergens": m.get("allergens", []),
        "timing_guidance": m.get("timingGuidance", ""),
        "calories": m["calories"],
        "protein_g": m["proteinG"],
        "carbs_g": m["carbsG"],
        "fat_g": m["fatG"],
        "portion": m.get("portion", "1 serving"),
        "recipe": m.get("recipe"),
        "recipe_available": m.get("recipeAvailable", False),
        "ingredient_tags": m.get("ingredientTags", []),
        "nutrition_notes": m.get("nutritionNotes", []),
    }


def _parse_dart_records(content: str, record_name: str) -> list[dict[str, str]]:
    """Parse FoodPharmerPointer / ProNutritionGuide const lists."""
    pattern = rf"{record_name}\(\s*([\s\S]*?)\s*\),"
    rows: list[dict[str, str]] = []
    for block in re.findall(pattern, content):
        fields: dict[str, str] = {}
        for m in re.finditer(
            r"(\w+):\s*(?:'((?:\\'|[^'])*)'|\"((?:\\\"|[^\"])*)\")",
            block,
        ):
            key = m.group(1)
            val = m.group(2) if m.group(2) is not None else m.group(3)
            fields[key] = val.replace("\\'", "'").replace('\\"', '"')
        if "id" in fields:
            rows.append(fields)
    return rows


def upsert_chunks(
    base_url: str,
    api_key: str,
    table: str,
    rows: list[dict],
    *,
    chunk_size: int = 40,
    dry_run: bool = False,
) -> int:
    if dry_run:
        print(f"  [dry-run] would upsert {len(rows)} rows into {table}")
        return len(rows)

    url = f"{base_url.rstrip('/')}/rest/v1/{table}"
    sent = 0
    headers = {
        "apikey": api_key,
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "Prefer": "resolution=merge-duplicates,return=minimal",
    }
    for i in range(0, len(rows), chunk_size):
        chunk = rows[i : i + chunk_size]
        req = urllib.request.Request(
            url,
            data=json.dumps(chunk).encode("utf-8"),
            headers=headers,
            method="POST",
        )
        try:
            with urllib.request.urlopen(req, timeout=120) as resp:
                if resp.status not in (200, 201, 204):
                    raise RuntimeError(f"Unexpected status {resp.status}")
        except urllib.error.HTTPError as e:
            body = e.read().decode("utf-8", errors="replace")
            raise RuntimeError(
                f"Upsert to {table} failed ({e.code}): {body[:800]}"
            ) from e
        sent += len(chunk)
        print(f"  {table}: {sent}/{len(rows)}")
    return sent


def maybe_apply_migration_003(database_url: str, dry_run: bool) -> None:
    if not MIGRATION_003.is_file():
        print("  migration 003 file missing — skip")
        return
    if dry_run:
        print("  [dry-run] would run migration 003 via psql")
        return
    proc = subprocess.run(
        ["psql", database_url, "-v", "ON_ERROR_STOP=1", "-f", str(MIGRATION_003)],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        if "already exists" in (proc.stderr + proc.stdout).lower():
            print("  migration 003: already applied (continuing)")
            return
        raise RuntimeError(
            f"psql migration 003 failed:\n{proc.stderr[:600] or proc.stdout[:600]}"
        )
    print("  migration 003 applied via psql")


def resolve_api_key(env: dict[str, str]) -> tuple[str, str]:
    for key in (
        "SUPABASE_SERVICE_ROLE_KEY",
        "SUPABASE_SERVICE_KEY",
        "SERVICE_ROLE_KEY",
    ):
        if env.get(key, "").strip():
            return env[key].strip(), key
    anon = env.get("SUPABASE_ANON_KEY", "").strip()
    if anon:
        print(
            "Warning: using SUPABASE_ANON_KEY — writes usually fail after migration 002. "
            "Add SUPABASE_SERVICE_ROLE_KEY to .env.local.",
            file=sys.stderr,
        )
        return anon, "SUPABASE_ANON_KEY"
    raise SystemExit(
        "Missing SUPABASE_SERVICE_ROLE_KEY (or SUPABASE_ANON_KEY) in .env.local"
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--tables",
        default="all",
        help="Comma-separated: exercises,meals,food_pharmer_pointers,pro_nutrition_guides,all",
    )
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument(
        "--env-file",
        type=Path,
        default=None,
        help="Path to env file (default: .env.local then .env in project root)",
    )
    args = parser.parse_args()

    raw = load_env_local(args.env_file)
    if not raw:
        raise SystemExit(
            f"No .env.local or .env found in {ROOT}. "
            "Copy .env.example → .env.local and add your service_role key."
        )
    env = normalize_env(raw)

    base_url = env.get("SUPABASE_URL", DEFAULT_URL).strip() or DEFAULT_URL
    api_key, key_name = resolve_api_key(env)
    print(f"Target: {base_url}")
    print(f"Auth: {key_name} ({len(api_key)} chars)")

    db_url = (
        env.get("DATABASE_URL")
        or env.get("SUPABASE_DB_URL")
        or env.get("POSTGRES_URL")
        or ""
    ).strip()
    if db_url and ("exercises" in args.tables or args.tables == "all"):
        print("Applying migration 003 (if needed)…")
        maybe_apply_migration_003(db_url, args.dry_run)

    want = {t.strip() for t in args.tables.split(",")}
    if "all" in want:
        want = {
            "exercises",
            "meals",
            "food_pharmer_pointers",
            "pro_nutrition_guides",
        }

    total = 0
    if "exercises" in want:
        data = json.loads(EXERCISES_JSON.read_text(encoding="utf-8"))
        rows = [exercise_row(ex) for ex in data]
        print(f"Upserting exercises ({len(rows)})…")
        total += upsert_chunks(base_url, api_key, "exercises", rows, dry_run=args.dry_run)

    if "meals" in want:
        data = json.loads(MEALS_JSON.read_text(encoding="utf-8"))
        rows = [meal_row(m) for m in data]
        print(f"Upserting meals ({len(rows)})…")
        total += upsert_chunks(base_url, api_key, "meals", rows, dry_run=args.dry_run)

    if "food_pharmer_pointers" in want or "pro_nutrition_guides" in want:
        dart = GUIDES_DART.read_text(encoding="utf-8")
        if "food_pharmer_pointers" in want:
            rows = _parse_dart_records(dart, "FoodPharmerPointer")
            print(f"Upserting food_pharmer_pointers ({len(rows)})…")
            total += upsert_chunks(
                base_url, api_key, "food_pharmer_pointers", rows, dry_run=args.dry_run
            )
        if "pro_nutrition_guides" in want:
            rows = _parse_dart_records(dart, "ProNutritionGuide")
            print(f"Upserting pro_nutrition_guides ({len(rows)})…")
            total += upsert_chunks(
                base_url, api_key, "pro_nutrition_guides", rows, dry_run=args.dry_run
            )

    print(f"Done — {total} row(s) processed.")


if __name__ == "__main__":
    main()