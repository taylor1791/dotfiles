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

  # Install Tools
  # Many of this will change files like .bashrc, so we install them before
  # coping over all the configuration files
  install_app curl
  install_app jq
  install_app silversearcher-ag
  install_app nvim neovim
  install_app git
  install_app direnv

  # Manually installs
  [[ ! -d ~/.nvm ]] && manual_install "nvm" 'curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash'

  # Configure neovim
  mkdir -p "$HOME/.config"
  full_file="$HOME/.config/nvim"
  clean_links "$full_file"
  link "$DIR/xdg/nvim" "$full_file"
  if [[ "$result" == "true" ]]; then
    nvim -u /dev/null -c 'PlugUpgrade' -c 'PlugInstall' -c 'qa'
  fi

  # Install home config
  cd "$DIR/home"
  for file in `find . -type f -maxdepth 1`; do
    full_file="$HOME/.$(basename $file)"
    clean_links "$full_file" "$file"
    link "$DIR/home/$file" "$full_file"
  done

  # Install directory configs
  for file in `find . -type f -mindepth 2 | cut -b 3-`; do
    mkdir -p $HOME/.$(dirname $file)
    link "$DIR/home/$file" "$HOME/.$file"
  done
}

# $1 in the command and $2 will be evaled if it does not exist
function manual_install() {
  if ! type "$1" > /dev/null 2>&1; then
    echo "Installing $1..."
    eval "$2"
  fi
}

# $1 is the binary name and $2 is the package name
function install_app() {
  BIN="$1"
  PKG="${2:-}"

  if [[ -z "$PKG" ]]; then
    PKG="$BIN"
  fi

  install "$BIN" "$PKG"
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

