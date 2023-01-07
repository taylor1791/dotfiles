{
  description = "NixOS modules for Taylor1791's workstations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = inputs: {
    devShell = inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.mkShell {
        buildInputs = [
          pkgs.just
          pkgs.nix-diff
        ];
      }
    );

    nixosConfigurations = {
      korolev = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/korolev ];
      };
    };
  };
}
