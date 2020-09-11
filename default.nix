with (import <nixpkgs> {});

{
  inherit jq tmux zoxide;
  inherit direnv lorri;

  tfswitch = import ./pkgs/tfswitch/default.nix {
    inherit buildGoPackage fetchFromGitHub;
  };
}
