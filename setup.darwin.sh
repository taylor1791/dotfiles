#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if ! type "brew" > /dev/null; then
  echo "Installing the homebrew package manager..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
fi

install() {
  if ! type "$1" > /dev/null; then
    echo "Installing $2..."
    brew install "$2"
  fi
}
