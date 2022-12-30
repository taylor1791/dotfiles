#!/usr/bin/env sh
set -e

if ! command -v nix > /dev/null; then
  . ~/.nix-profile/etc/profile.d/nix.sh
fi

nix-env --install --file ~/.config/dotfiles/default.nix
