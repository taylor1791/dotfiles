{ pkgs, writeShellApplication, ... }:
let
  secretsScript = ./secrets.nu;
in writeShellApplication {
  name = "secrets";
  runtimeInputs = [ pkgs.nushell pkgs.vault-bin ];
  text = ''
    nu ${secretsScript} "$@"
  '';
}
