with (import <nixpkgs> {});

{
  inherit gnupg jq htop ripgrep tmux vim wget zoxide;
  inherit direnv lorri;

  tfswitch = import ./pkgs/tfswitch/default.nix {
    inherit buildGoPackage fetchFromGitHub;
  };
}
