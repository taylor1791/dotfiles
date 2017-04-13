#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

install() {
  if ! type "$1" > /dev/null; then
    echo "Installing $1..."
    apt-get install -y "$@"
  fi
}

