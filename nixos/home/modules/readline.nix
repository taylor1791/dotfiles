{ config, lib, ... }: let
  programName = "readline";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's readline configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.readline = {
      enable = true;

      extraConfig = ''
        set editing-mode vi
      '';
    };
  };
}
