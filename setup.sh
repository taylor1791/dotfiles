#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

for script in scripts.d/*.sh; do
  . $script
done
