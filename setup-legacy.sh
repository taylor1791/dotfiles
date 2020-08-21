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

  # Install really essentail things
  install_app curl
  install_app git

  # Install home config
  pushd "$DIR/home" > /dev/null
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
  popd > /dev/null

  # Install Tools
  install_app shuf coreutils
  install_app ripgrep
  install_app vim
  install_app direnv
  install_app fnm
  install_app oathtool oathtool
  install_app "/usr/local/etc/profile.d/z.sh" z

  # Install fonts
  for f in `find fonts/ -name '*.ttf'`; do
    if [[ ! -f "$FONT_DIRECTORY/$(basename $f)" ]]; then
      echo Installing $(basename "$f")
      cp "$f" "$FONT_DIRECTORY"
    fi
  done

  # Configure vim
  mkdir -p ~/.vim/.{undo,backup,swap}
  vim -u /dev/null -c 'PlugUpgrade' -c 'PlugInstall' -c 'qa'
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
  CHECK="$1"
  PKG="${2:-}"

  if [[ -z "$PKG" ]]; then
    PKG="$CHECK"
  fi

  if [[ $CHECK == /* ]]; then
    [[ ! -f "$CHECK" ]] && install "$PKG" || true
  elif ! type "$1" > /dev/null 2>&1; then
    install "$PKG"
  fi
}

function install_cron() {
  if ! crontab -l | grep -Fq "$1"; then
    echo "Installing cron: $1"
    crontab -l || true | { cat; echo "$1"; } | crontab -
  fi
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
