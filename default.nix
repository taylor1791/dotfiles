with (import <nixpkgs> {});

{
  # Environment Management
  inherit direnv lorri;

  # Development Tools
  inherit gnupg jq ripgrep tree tmux vim wget zoxide;

  # Investigation Tools
  inherit htop tcptraceroute traceroute

  # "Primary-machine" tools
  inherit (oath-toolkit);

  tfswitch = import ./pkgs/tfswitch/default.nix {
    inherit buildGoPackage fetchFromGitHub;
  };
}
