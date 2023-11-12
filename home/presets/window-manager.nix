{ config, lib, ... }: let
  presetName = "window-manager";
  cfg = config.presets.${presetName};
  presetOptions = import ./options.nix { inherit lib; };
in {
  options.presets.${presetName} = presetOptions.window-manager;

  config = lib.mkIf cfg.enable {
    taylor1791.programs.rofi.enable = true;
    taylor1791.programs.xmobar.enable = true;
    taylor1791.programs.xmonad.enable = true;
  };
}
