{ config, lib, ... }: let
  presetName = "shell";
  cfg = config.presets.${presetName};
in {
  options = {
    presets.shell = {
      enable = lib.mkEnableOption "Enable dotfiles for routine shell access";
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
