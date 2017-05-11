#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if ! type "brew" > /dev/null 2>&1; then
  echo "Installing the homebrew package manager..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
fi

install() {
  NAME="$2"

  if [[ "$NAME" == "silversearcher-ag" ]]; then
    NAME="the_silver_searcher"
  fi

  if ! type "$1" > /dev/null 2>&1; then
    echo "Installing $NAME..."
    brew install "$NAME"
  fi
}

setup_neovim() {
  brew tap neovim/neovim
}

setup_neovim
