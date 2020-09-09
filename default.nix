with (import <nixpkgs> {});

{
  inherit jq;
  inherit direnv;

  tfswitch = import ./pkgs/tfswitch/default.nix {
    inherit buildGoPackage fetchFromGitHub;
  };
}
