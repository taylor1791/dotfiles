{ lib, pkgs, ... }: {
  home-manager.users.teverding.home.stateVersion = "23.05";
  home-manager.users.teverding.taylor1791.programs.alacritty.fontSize = 17.0;
  nix.settings.experimental-features = "nix-command flakes";
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  taylor1791.presets.taylor1791DarwinSystem.enable = true;

  taylor1791.home.users.teverding =
    { stateVersion = "23.05"; } //
    (import ../../home/profiles.nix { inherit lib; }).genericTaylor1791;
}
