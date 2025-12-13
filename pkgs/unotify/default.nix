{ pkgs, writeShellApplication, ... }:
let
  unotifyScript = ./unotify.nu;
in writeShellApplication {
  name = "unotify";
  runtimeInputs = [ pkgs.nushell ];

  text = ''
    nu ${unotifyScript} "$@"
  '';
}
