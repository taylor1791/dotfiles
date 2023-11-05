{ pkgs, self, ... }: {
  home-manager.users.teverding.home.stateVersion = "23.05";
  nix.settings.experimental-features = "nix-command flakes";
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
