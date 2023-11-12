{ config, lib, pkgs, ... }: let
  presetName = "pc";
  cfg = config.presets.${presetName};
  presetOptions = import ./options.nix { inherit lib; };
in {
  options.presets.${presetName} = presetOptions.pc;

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      minisign
      rage
      taylor1791.borgbackup
      taylor1791.bopen
      taylor1791.mirror
      taylor1791.rand
      taylor1791.totp
      unzip
      wget
      zip
    ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      sshfs
    ];
  };
}
