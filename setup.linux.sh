#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

install() {
  if ! type "$1" > /dev/null; then
    echo "Installing $2..."
    sudo apt-get install -y "$2"
  fi
}

setup_neovim() {
  sudo apt-get update
  sudo install software-properties-common
  sudo install python-software-properties
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt-get update
}

setup_neovim

