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
  for file in `ls $DIR/home`; do
    full_file="$HOME/.$file"

    clean_links "$full_file" "$file"

    # Add the link
    if [ ! -e "$full_file" ]; then
      echo "Adding link for $file...";
      ln -s "$DIR/home/$file" "$full_file" 
    fi
  done

  # Configure neovim
  full_file="$HOME/.config/nvim"
  clean_links "$full_file"
  if [ ! -e "$full_file" ]; then
    echo "Adding link for nvim...";
    ln -s "$DIR/xdg/nvim" "$full_file"
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

main

