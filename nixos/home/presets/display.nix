{ config, lib, pkgs, ... }: let
  presetName = "display";
  cfg = config.presets.${presetName};
  presetOptions = import ./options.nix { inherit lib; };
in {
  options.presets.${presetName} = presetOptions.display;

  config = lib.mkIf cfg.enable {
    taylor1791.programs.alacritty.enable = true;
    taylor1791.programs.zathura.enable = true;

    home.packages = [
      pkgs.taylor1791.color
    ];
  };
}
