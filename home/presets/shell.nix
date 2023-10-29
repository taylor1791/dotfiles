{ config, lib, ... }: let
  presetName = "shell";
  cfg = config.presets.${presetName};
in {
  options = {
    presets.${presetName} = {
      enable = lib.mkEnableOption "Enable dotfiles for routine shell access";
    };
  };

  config = lib.mkIf cfg.enable {
    taylor1791.programs.bash.enable = true;
    taylor1791.programs.readline.enable = true;
  };
}
