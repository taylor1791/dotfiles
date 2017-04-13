#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function main() {
  PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

  # Inherit platform functions
  PLATFORM_COMMANDS=$DIR/setup.$PLATFORM.sh
  if [ ! -f $PLATFORM_COMMANDS ]; then
    die "Unsupported Platform: $PLATFORM"
  fi
  source $PLATFORM_COMMANDS

  # Install essential tools
  install jq

  # Install home config
  cd "$DIR/home"
  for file in `find . -type f -depth 1`; do
    full_file="$HOME/.$(basename $file)"
    clean_links "$full_file" "$file"
    link "$DIR/home/$file" "$full_file"
  done

  # Install directory configs
  for file in `find . -type f -mindepth 2 | cut -b 3-`; do
    mkdir -p $(dirname $file)
    link "$DIR/home/$file" "$HOME/.$file"
  done

  # Configure neovim
  full_file="$HOME/.config/nvim"
  clean_links "$full_file"
  link "$DIR/xdg/nvim" "$full_file"
  if [[ "$result" == "true" ]]; then
    nvim -c 'PlugUpgrade' -c 'PlugInstall' -c 'qa'
  fi

  # FIXME Install software: neovim, nvim, direnv
  # FIXME Warn on outdated stuff
}

function die() {
  tput bold
  tput setaf 3
  echo "$@"
  tput sgr0
  exit 1;
}

function clean_links() {
  # Kill pre-existing invalid links
  if [[ -L "$1" && ! -e "$1" ]]; then
    echo "Killing $2 invalid link..."
    rm "$1"
  fi

  # Backup existing configs
  if [[ -e "$1" && ! -h "$1" ]]; then
    echo "Backing up $2..."
    mv "$1" "$1.$(date +%s)"
  fi
}

function link() {
  if [ ! -e "$2" ]; then
    echo "Linking $2...";
    ln -s "$1" "$2"
    result="true"
  else
    result="false"
  fi
}

main

