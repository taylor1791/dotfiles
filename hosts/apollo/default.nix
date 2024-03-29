{ lib, pkgs, ... }: {
  imports = [ ../../darwin/hacks.nix ];

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.system = "aarch64-darwin";
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  taylor1791.presets.taylor1791DarwinSystem.enable = true;

  home-manager.users.tayloreverding.taylor1791.programs.alacritty = {
    extraSettings = {
      font.size = 15.0;

      shell = {
        program = "login";
        args = [ "-fp" "tayloreverding" ];
      };
    };
  };

  taylor1791.home = let
    user = "tayloreverding";
  in {
    users.${user}.stateVersion = "23.05";

    profiles.taylor1791.desktop = {
      inherit user;

      enable = true;
    };
  };
}
