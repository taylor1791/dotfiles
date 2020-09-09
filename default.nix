with (import <nixpkgs> {});

{
  inherit jq;

  tfswitch = import ./pkgs/tfswitch/default.nix {
    inherit buildGoPackage fetchFromGitHub;
  };
}
