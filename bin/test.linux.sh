#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

apt-get update
apt-get install -y sudo man-db

