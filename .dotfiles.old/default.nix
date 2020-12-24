with (import <nixpkgs> {});

{
  # "Primary-machine" tools
  inherit (oath-toolkit);

  tfswitch = callPackage ./pkgs/tfswitch/default.nix { };
  my_weechat = weechat.override {
    configure = { availablePlugins, ... }: {
       plugins = with availablePlugins; [ python perl ];
    }
  };
}
