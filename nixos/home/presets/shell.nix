{ config, lib, pkgs, ... }: let
  presetName = "shell";
  cfg = config.presets.${presetName};
  presetOptions = import ./options.nix { inherit lib; };
in {
  options.presets.${presetName} = presetOptions.shell;

  config = lib.mkIf cfg.enable {
    taylor1791.programs.bash.enable = true;
    taylor1791.programs.neovim.enable = true;
    taylor1791.programs.readline.enable = true;

    home.packages = with pkgs; [
      tree
    ];
  };
}
