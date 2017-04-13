#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

install() {
  if ! type "$1" > /dev/null; then
    echo "Installing $2..."
    apt-get install -y "$2"
  fi
}

setup_neovim() {
  apt-apt update
  install software-properties-common
  install python-software-properties
  add-apt-repository -y ppa:neovim-ppa/stable
  apt-apt update
}

setup_neovim
