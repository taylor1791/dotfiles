{ config, lib, pkgs, ...}: let
  serviceName = "console";
  cfg = config.taylor1791.services.${serviceName};
in {
  options.taylor1791.services.${serviceName} = {
    enable = lib.mkEnableOption "Configures systems with at least console access.";
  };

  config = lib.mkIf cfg.enable {
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    i18n.defaultLocale = "en_US.UTF-8";
    environment.systemPackages = with pkgs; [ vim ];

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
