with (import <nixpkgs> {});

let
  eslint = nodePackages.eslint;
  prettier = nodePackages.prettier;
  write-good = nodePackages.write-good;
in
{
  # Environment Management
  inherit direnv lorri;

  # Development Tools
  inherit httpie gnupg jq ripgrep neovim sc-im
    skim tree watch watchexec wget zoxide;

  # Language Tools
  inherit hadolint;             # Docker
  inherit proselint write-good; # English
  inherit eslint prettier;      # JavaScript
  inherit shellcheck;           # Shell
  inherit tflint;               # Terraform
  inherit vim-vint;             # Vim

  # Investigation Tools
  inherit htop tcptraceroute;

  # Command Line Tools
  inherit oathToolkit rage unzip;

  # Command Line Apps
  inherit ranger;

  # Desktop Apps
  inherit alacritty zathura;
} // (if !pkgs.stdenv.isDarwin then {
  # The following packages do not support darwin.

  # Investigation Tools
  inherit traceroute;

  # Personal Tools
  inherit sshfs;

  # Desktop Apps
  inherit firefox;
} else {
})
