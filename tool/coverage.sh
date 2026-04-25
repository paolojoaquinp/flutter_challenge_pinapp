#!/usr/bin/env bash
# Runs the test suite with coverage and enforces a >=80% line coverage gate
# on the business logic (entities, models, repositories, datasources, notifiers).
# UI pages, widgets, splash, and infrastructure singletons are excluded.
set -euo pipefail

cd "$(dirname "$0")/.."

flutter test --coverage

if ! command -v lcov >/dev/null 2>&1; then
  echo "lcov not found. Install via: brew install lcov" >&2
  exit 1
fi

lcov --remove coverage/lcov.info \
  --ignore-errors unused \
  'lib/main.dart' \
  'lib/firebase_options.dart' \
  'lib/src/core/local_storage/*' \
  'lib/src/core/remote_config/*' \
  'lib/src/core/network/dio_client.dart' \
  'lib/src/core/utils/*' \
  'lib/src/features/*/presentation/page/*' \
  'lib/src/features/*/presentation/widgets/*' \
  'lib/src/features/shared/presentation/*' \
  'lib/src/features/splash/*' \
  -o coverage/lcov.filtered.info

pct=$(lcov --summary coverage/lcov.filtered.info 2>&1 \
  | awk -F'[ %]+' '/lines/ {print $3; exit}')

echo ""
echo "===================================="
echo "Line coverage: ${pct}%"
echo "===================================="

awk -v p="$pct" 'BEGIN { if (p+0 < 80) { print "FAIL: coverage below 80%"; exit 1 } else { print "PASS: coverage >= 80%" } }'
