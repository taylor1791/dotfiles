PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

if [[ "${PLATFORM}" == "darwin" ]]; then
  sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
else
  curl -L https://nixos.org/nix/install | sh
fi
