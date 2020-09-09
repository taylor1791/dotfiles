with (import <nixpkgs> {});

{
  inherit jq tmux;
  inherit direnv;

  tfswitch = import ./pkgs/tfswitch/default.nix {
    inherit buildGoPackage fetchFromGitHub;
  };
}
