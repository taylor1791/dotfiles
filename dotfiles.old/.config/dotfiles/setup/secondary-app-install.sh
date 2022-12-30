#!/usr/bin/env bash
set -e

PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

if [[ "${PLATFORM}" == "darwin" ]]; then
  if ! type brew> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if ! [[ -e /Applications/Amethyst.app ]]; then
    brew install amethyst
  fi

  if ! [[ -e /Applications/Amethyst.app ]]; then
    brew install amethyst
  fi

  if ! [[ -e /Applications/Chromium.app ]]; then
    brew install chromium
  fi

  if ! [[ -e /Applications/Google\ Chrome.app ]]; then
    brew install google-chrome
  fi

  if ! [[ -e ~/Library/Fonts/mononoki-Regular.ttf ]]; then
    brew tap homebrew/cask-fonts
    brew install font-mononoki
  fi
fi
