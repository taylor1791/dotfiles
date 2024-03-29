{ lib, pkgs, ... }: {
  imports = [ ../../darwin/hacks.nix ];
  home-manager.users.teverding.home.stateVersion = "23.05";
  nix.settings.experimental-features = "nix-command flakes";
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  taylor1791.presets.taylor1791DarwinSystem.enable = true;

  taylor1791.home = let
    user = "teverding";
  in {
    users.${user}.stateVersion = "23.05";

    profiles.taylor1791.desktop = {
      inherit user;
      enable = true;
    };
  };

  home-manager.users.teverding.taylor1791.programs.alacritty.extraSettings = {
    font.size = 17.0;

    shell = {
      program = "login";
      args = [ "-fp" "teverding" ];
    };
  };
}
