#!/usr/bin/env bash
set -euo pipefail
file=target-lock/CP3A.261005.005/README.md
test -f "$file"
grep -q 'CP3A.261005.005' "$file"
grep -q '6.1.162-android14-11' "$file"
grep -q 'Required before a device-specific artifact' "$file"
echo 'target-lock: valid'
