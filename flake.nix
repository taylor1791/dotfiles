{
  description = "NixOS modules for Taylor1791's workstations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = inputs: {
      nixosConfigurations = {
        korolev = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/korolev ];
        };
      };
    };
}
