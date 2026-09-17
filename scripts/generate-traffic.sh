#!/usr/bin/env bash
set -euo pipefail

: "${APP_URL:?Set APP_URL, for example http://34.1.2.3}"
REQUESTS="${REQUESTS:-100}"

for ((i=1; i<=REQUESTS; i++)); do
  curl --silent --output /dev/null "${APP_URL}/work?delay_ms=$((20 + RANDOM % 400))"
  if (( i % 20 == 0 )); then
    curl --silent --output /dev/null "${APP_URL}/error" || true
  fi
done

echo "Generated ${REQUESTS} requests with one synthetic 500 per 20 requests."

