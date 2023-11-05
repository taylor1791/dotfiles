nixos_cmd := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }

diff_current_system:
  nixos-rebuild build --flake . && nix-diff /run/current-system ./result

switch:
  {{nixos_cmd}} switch --flake .
