with (import <nixpkgs> {});

let
  previous = import (fetchTarball https://nixos.org/channels/nixos-20.09/nixexprs.tar.xz) { };

  sc-im = previous.sc-im;
  eslint = nodePackages.eslint;
  prettier = nodePackages.prettier;
  write-good = nodePackages.write-good;
in
{
  # Development Tools
  inherit gnupg jq neovim sc-im tree watch wget zip;

  # Next Gen Development tools
  inherit dogdns miniserve watchexec xh;

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
