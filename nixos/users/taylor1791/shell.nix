{ config, lib, ... }: let
  profileName = "shell";
  cfg = config.taylor1791.home.profiles.taylor1791.${profileName};
in {
  options.taylor1791.home.profiles.taylor1791.${profileName} = {
    enable = lib.mkEnableOption "Create a user with the shell preset enabled";

    user = lib.mkOption {
      type = lib.types.str;
      default = "taylor1791";
      description = "The user for which to enable this profile";
    };
  };

  config = lib.mkIf cfg.enable {
    taylor1791.home.users.${cfg.user}.presets.shell.enable = true;
  };
}
