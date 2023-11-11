{ config, lib, pkgs, ...}: let
  serviceName = "development";
  cfg = config.taylor1791.presets.${serviceName};
in {
  options.taylor1791.presets.${serviceName} = {
    enable = lib.mkEnableOption "Configures systems where development occurs.";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.taylor1791.presets.shell.enable;
        message = "Development requires a shell. Set taylor1791.shell.enabled = true";
      }
    ];

    users.users.${config.taylor1791.presets.shell.user}.extraGroups = [ "docker" "keys" ];
    virtualisation.docker.enable = true;
  };
}
