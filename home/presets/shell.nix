{ config, lib, pkgs, ... }: let
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

    home.packages = with pkgs; [
      minisign
      rage
      taylor1791.bopen
      taylor1791.mirror
      taylor1791.rand
      taylor1791.totp
      tree
      unzip
      wget
      zip
    ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      sshfs
    ];
  };
}
