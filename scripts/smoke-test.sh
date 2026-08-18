#!/bin/sh
set -eu
base=${CLOUDFORGE_URL:-https://127.0.0.1:8443}
curl --fail --silent --show-error --insecure "$base/proxy-health" | grep -q '^ok$'
curl --fail --silent --show-error --insecure "$base/health/live" | grep -q '"status": "alive"'
curl --fail --silent --show-error --insecure "$base/health/ready" | grep -q '"status": "ready"'
echo 'proxy, liveness, and readiness checks passed'
