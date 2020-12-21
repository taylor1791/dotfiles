with (import <nixpkgs> {});

{
  # Environment Management
  inherit direnv lorri;

  # Development Tools
  inherit gnupg jq pandoc ripgrep sc-im skim tree tmux vault vim watch watchexec wget zoxide;

  # Investigation Tools
  inherit htop tcptraceroute traceroute

  # "Primary-machine" tools
  inherit (oath-toolkit);

  tfswitch = callPackage ./pkgs/tfswitch/default.nix { };
  my_weechat = weechat.override {
    configure = { availablePlugins, ... }: {
       plugins = with availablePlugins; [ python perl ];
    }
  };
}
