with (import <nixpkgs> {});

{
  inherit jq tmux;
  inherit direnv lorri;

  tfswitch = import ./pkgs/tfswitch/default.nix {
    inherit buildGoPackage fetchFromGitHub;
  };
}
