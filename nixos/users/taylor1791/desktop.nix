{ config, lib, ... }: let
  profileName = "desktop";
  cfg = config.taylor1791.home.profiles.taylor1791.${profileName};
in {
  options.taylor1791.home.profiles.taylor1791.${profileName} = {
    enable = lib.mkEnableOption "Create a desktop user";

    user = lib.mkOption {
      type = lib.types.str;
      default = "taylor1791";
      description = "The user for which to enable this profile";
    };
  };

  config = lib.mkIf cfg.enable {
    taylor1791.home.users.${cfg.user}.presets = {
      display.enable = true;
      pc.enable = true;
      troubleshooting.enable = true;

      development = {
        enable = true;
        email = "taylor1791@users.noreply.github.com";
        name = "Taylor Everding";
      };
    };

    taylor1791.home.profiles.taylor1791.shell = {
      enable = true;
      user = cfg.user;
    };
  };
}

