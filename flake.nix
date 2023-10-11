{
  description = "NixOS derivations supporting Taylor1791.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = { nixpkgs, self }: let
    lib = nixpkgs.lib;
  in {
    devShell = lib.genAttrs lib.systems.flakeExposed (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in pkgs.mkShell {
        buildInputs = with pkgs; [ just nix-diff ];
      }
    );

    nixosConfigurations = {
      korolev = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/korolev ];
      };
    };
  };
}
