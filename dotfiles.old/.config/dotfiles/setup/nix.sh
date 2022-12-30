#!/usr/bin/env bash
set -e

PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

# NixOS now recommends installing the deamon. I haven't test that yet.
if ! command -v nix > /dev/null; then
  if [[ "${PLATFORM}" == "darwin" ]]; then
    sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
  else
    curl -L https://nixos.org/nix/install | sh
  fi
fi
