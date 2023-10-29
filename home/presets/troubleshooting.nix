{ config, lib, options, pkgs, ... }: let
  presetName = "troubleshooting";
  cfg = config.presets.${presetName};
in {
  options = {
    presets.${presetName} = {
      enable = lib.mkEnableOption "Enable troubleshooting tools";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dogdns
      htop
      tcptraceroute
    ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      iotop
      nethogs
      traceroute
    ];
  };
}
