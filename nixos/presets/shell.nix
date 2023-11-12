{ config, lib, pkgs, ...}: let
  serviceName = "shell";
  cfg = config.taylor1791.presets.${serviceName};
in {
  options.taylor1791.presets.${serviceName} = {
    enable = lib.mkEnableOption "Configures systems with at least shell access.";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh.startAgent = true;
    services.openssh.enable = true;
    taylor1791.presets.console.enable = true;
  };
}
