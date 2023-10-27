{ config, lib, pkgs, ... }: let
  presetName = "development";
  cfg = config.presets.${presetName};
in {
  options = {
    presets.${presetName} = {
      enable = lib.mkEnableOption "Enable developer tools";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      direnv
      ripgrep
      skim
      neovim
      zoxide
    ];
  };
}
