with (import <nixpkgs> {});

let
  previous = import (fetchTarball https://nixos.org/channels/nixos-20.09/nixexprs.tar.xz) { };

  sc-im = previous.sc-im;
  eslint = nodePackages.eslint;
  prettier = nodePackages.prettier;
  write-good = nodePackages.write-good;
in
{
  # Next Gen Development tools
  inherit dogdns;

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
} // (if !pkgs.stdenv.isDarwin then {
  # The following packages do not support darwin.

  # Investigation Tools
  inherit traceroute;

  # Desktop Apps
  inherit firefox;
} else {
})
