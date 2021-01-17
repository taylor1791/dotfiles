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
  inherit gnupg jq ripgrep sc-im skim tree vim watch watchexec wget zoxide;

  # Language Tools
  inherit hadolint;             # Docker
  inherit proselint write-good; # English
  inherit eslint prettier;      # JavaScript
  inherit shellcheck;           # Shell
  inherit tflint;               # Terraform
  inherit vim-vint;             # Vim

  # Investigation Tools
  inherit htop tcptraceroute;

  # Personal Tools
  inherit oathToolkit rage unzip;

  # Desktop Tools
  inherit alacritty zathura;
} // (if !pkgs.stdenv.isDarwin then {
  # The following packages do not support darwin.

  # Investigation Tools
  inherit traceroute;

  # Personal Tools
  inherit sshfs;

  # Desktop Tools
  inherit firefox;
} else {
})
