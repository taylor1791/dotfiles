{ config, lib, pkgs, ...}: let
  serviceName = "shell";
  cfg = config.taylor1791.services.${serviceName};
in {
  options.taylor1791.services.${serviceName} = {
    enable = lib.mkEnableOption "Configures systems with at least shell access.";

    user = lib.mkOption {
      type = lib.types.str;
      description = "The primary user of the system.";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.trusted-users = [ cfg.user ];
    programs.ssh.startAgent = true;
    services.openssh.enable = true;
    taylor1791.services.console.enable = true;

    users.users.${cfg.user} = {
      isNormalUser = true;
      extraGroups = [ cfg.user "wheel" ];
    };
  };
}
