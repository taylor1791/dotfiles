{ config, lib, pkgs, ... }: let
  presetName = "display";
  cfg = config.presets.${presetName};
in {
  options = {
    presets.${presetName} = {
      enable = lib.mkEnableOption "Enable dotfiles for systems with a display";
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
