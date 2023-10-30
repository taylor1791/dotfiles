{ config, lib, ... }: let
  presetName = "window-manager";
  cfg = config.presets.${presetName};
in {
  options = {
    presets.${presetName} = {
      enable = lib.mkEnableOption "Enable dotfile for systems with window mangers";
    };
  };

  config = lib.mkIf cfg.enable {
    taylor1791.programs.rofi.enable = true;
    taylor1791.programs.xmobar.enable = true;
  };
}
