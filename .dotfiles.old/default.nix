with (import <nixpkgs> {});

{
  tfswitch = callPackage ./pkgs/tfswitch/default.nix { };
  my_weechat = weechat.override {
    configure = { availablePlugins, ... }: {
       plugins = with availablePlugins; [ python perl ];
    }
  };
}
