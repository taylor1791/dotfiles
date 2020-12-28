with (import <nixpkgs> {});

{
  # Environment Management
  inherit direnv lorri;

  # Development Tools
  inherit gnupg jq ripgrep sc-im skim tree vim watch watchexec wget zoxide;

  # Investigation Tools
  inherit htop tcptraceroute;

  # Desktop Tools
  inherit alacritty;
} // (if !pkgs.stdenv.isDarwin then {
  # The following packages do not support darwin.

  # Investigation Tools
  inherit traceroute;

  # Desktop Tools
  inherit firefox;
} else {
})
