diff_current_system:
  nixos-rebuild build --flake . && nix-diff /run/current-system ./result
