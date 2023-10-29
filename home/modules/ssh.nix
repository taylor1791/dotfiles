{ config, lib, ... }: let
  programName = "ssh";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's ssh configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      includes = [ "config.local" ];

      matchBlocks."*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
