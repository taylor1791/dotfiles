{ config, lib, pkgs, ... }: let
  presetName = "troubleshooting";
  cfg = config.presets.${presetName};
  presetOptions = import ./options.nix { inherit lib; };
in {
  options.presets.${presetName} = presetOptions.troubleshooting;

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
