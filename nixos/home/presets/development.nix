{ config, lib, pkgs, ... }: let
  presetName = "development";
  cfg = config.presets.${presetName};
  presetOptions = import ./options.nix { inherit lib; };
in {
  options.presets.${presetName} = presetOptions.development;

  config = lib.mkIf cfg.enable {
    taylor1791.programs.ssh.enable = true;

    home.packages = with pkgs; [
      direnv
      pkgs.taylor1791.claude-code
      pkgs.taylor1791.fire
      pkgs.taylor1791.fireconnect
      fd
      fzf
      git
      hyperfine
      jq
      miniserve
      ripgrep
      taylor1791.secrets
      taylor1791.unotify
      viddy
      watchexec
      xh
      zoxide
    ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      zsa-udev-rules
    ];

    taylor1791.programs.neovim = {
      enable = true;
      ai = true;
      development = true;
    };

    taylor1791.programs.git = {
      enable = true;
      email = cfg.email;
      name = cfg.name;
    };
  };
}
