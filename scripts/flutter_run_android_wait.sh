#!/usr/bin/env bash
# Launch an AVD if needed, wait until adb + Flutter see it, then flutter run.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AVD="${1:-Pixel_9a}"
DEVICE_ID="${2:-}"

cd "${ROOT}"

_android_serial() {
  adb devices | awk '/^emulator-[0-9]+[[:space:]]+device$/{print $1; exit}'
}

if [[ -z "${DEVICE_ID}" ]]; then
  DEVICE_ID="$(_android_serial || true)"
fi

if [[ -z "${DEVICE_ID}" ]]; then
  echo "Starting AVD ${AVD} (boot can take 1–2 minutes)…" >&2
  flutter emulators --launch "${AVD}" || true
  echo "Waiting for adb device…" >&2
  adb wait-for-device
  DEVICE_ID="$(_android_serial)"
fi

echo "Waiting for Android boot to finish…" >&2
for _ in $(seq 1 90); do
  boot="$(adb -s "${DEVICE_ID}" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' || true)"
  if [[ "${boot}" == "1" ]]; then
    break
  fi
  sleep 2
done

if ! flutter devices | rg -q "${DEVICE_ID}"; then
  echo "Device ${DEVICE_ID} not visible to Flutter yet — try: flutter devices" >&2
  exit 1
fi

echo "Running on ${DEVICE_ID}…" >&2
exec "${ROOT}/scripts/flutter_run_local.sh" -d "${DEVICE_ID}"