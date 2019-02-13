#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if ! type "brew" > /dev/null 2>&1; then
  echo "Installing the homebrew package manager..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
fi

install() {
  NAME="$1"

  echo "Installing $NAME..."

  if [[ "$NAME" == "fnm" ]]; then
    curl -L -O https://github.com/Schniz/fnm/releases/download/v1.2.1/fnm-macos.zip
    unzip -j fnm-macos.zip -d ~/.bin/
    chmod +x ~/.bin/fnm
    rm fnm-macos.zip
  elif [[ "$NAME" == "silversearcher-ag" ]]; then
    brew install the_silver_searcher
  else
    brew install "$NAME"
  fi

}
