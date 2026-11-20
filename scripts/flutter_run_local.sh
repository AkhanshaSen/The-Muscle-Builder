#!/usr/bin/env bash
# Run Flutter with SUPABASE_ANON_KEY from .env.local (gitignored).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ROOT}/.env.local"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE} — copy .env.example to .env.local" >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a
source "${ENV_FILE}"
set +a

ANON_KEY="${SUPABASE_ANON_KEY:-${NEXT_PUBLIC_SUPABASE_ANON_KEY:-}}"
if [[ -z "${ANON_KEY}" ]]; then
  echo "Set SUPABASE_ANON_KEY or NEXT_PUBLIC_SUPABASE_ANON_KEY in .env.local" >&2
  exit 1
fi

cd "${ROOT}"
exec flutter run \
  --dart-define=SUPABASE_ANON_KEY="${ANON_KEY}" \
  "$@"