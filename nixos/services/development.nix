{ config, lib, pkgs, ...}: let
  serviceName = "development";
  cfg = config.taylor1791.services.${serviceName};
in {
  options.taylor1791.services.${serviceName} = {
    enable = lib.mkEnableOption "Configures systems where development occurs.";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.taylor1791.services.shell.enable;
        message = "Development requires a shell. Set taylor1791.shell.enabled = true";
      }
    ];

    environment.systemPackages = with pkgs; [
      git
      hyperfine
      zsa-udev-rules
    ];

    users.users.${config.taylor1791.services.shell.user}.extraGroups = [ "docker" "keys" ];
    virtualisation.docker.enable = true;
  };
}
