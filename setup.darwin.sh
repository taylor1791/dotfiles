#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

FONT_DIRECTORY="$HOME/Library/fonts"

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
  elif [[ "$NAME" == "oathtool" ]]; then
    brew install oath-toolkit
  else
    brew install "$NAME"
  fi

}

install_cask() {
  NAME="$1"
  SIGNATURE="$2"

  if [[ ! -e "$SIGNATURE" ]]; then
    echo "Installing $NAME..."
    brew cask install "$NAME"
  fi
}

install_chrome_beta() {
  SIGNATURE="/Applications/Google Chrome Beta.app"
  if [[ ! -d "$SIGNATURE" ]]; then
    install_cask homebrew/cask-versions/google-chrome-beta "$SIGNATURE"
    mv "/Applications/Google Chrome.app" "/Applications/Google Chrome Beta.app"
  fi
}

install_cask amethyst "/Applications/Amethyst.app"
install_cask keka "/Applications/Keka.app"
install_cask steam "/Applications/Steam.app"
install_cask iterm2 "/Applications/iTerm.app"
install_cask virtualbox "/Applications/VirtualBox.app"
install_cask vagrant "/opt/vagrant/bin/vagrant"
install_cask docker "/Applications/Docker.app"
