{ config, lib, options, pkgs, ... }: let
  presetName = "development";
  cfg = config.presets.${presetName};
in {
  options = {
    presets.${presetName} = {
      enable = lib.mkEnableOption "Enable developer tools";
      email = options.taylor1791.programs.git.email;
      name = options.taylor1791.programs.git.name;
    };
  };

  config = lib.mkIf cfg.enable {
    taylor1791.programs.ssh.enable = true;

    home.packages = with pkgs; [
      direnv
      ripgrep
      skim
      neovim
      zoxide
    ];

    taylor1791.programs.git = {
      enable = true;
      email = cfg.email;
      name = cfg.name;
    };
  };
}
