{
  description = "NixOS derivations supporting Taylor1791.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, self }: let
    lib = nixpkgs.lib;
    profiles = import ./home/profiles.nix { inherit lib; };

    modules = [
      ./home/modules/default.nix
      ./home/presets/default.nix
    ];
  in {
    devShell = lib.genAttrs lib.systems.flakeExposed (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in pkgs.mkShell {
        buildInputs = with pkgs; [ just nix-diff ];
      }
    );

    homeConfigurations = let
      allSystems = lib.systems.flakeExposed;
      systems = builtins.filter (lib.strings.hasSuffix "-linux") allSystems;

      mkHomeModules = { home, system }: {
        name = "${home.username}_${system}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = modules ++ [
            { home.homeDirectory = "/home/${home.username}"; }
            { home.stateVersion = "23.05"; }
            { home.username = home.username; }
            home.module
          ];
        };
      };
    in
      builtins.listToAttrs (
        builtins.map mkHomeModules (lib.cartesianProductOfSets {
          home = [
            { username = "taylor1791"; module = profiles.genericTaylor1791; }
          ];
          system = systems;
        })
      );

    nixosConfigurations = let
      mkHomeModules = user: module : [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            users.${user} = { imports = modules; } // module;
          };
        }
      ];
    in {
      korolev = lib.nixosSystem {
        system = "x86_64-linux";
        modules = (builtins.attrValues self.nixosModules) ++
          [ ./hosts/korolev ] ++
          mkHomeModules
            "taylor1791"
            (profiles.nixosTaylor1791 // { home.stateVersion = "23.05"; });
      };
    };

    nixosModules = {
      console = import ./nixos/services/console.nix;
      development = import ./nixos/services/development.nix;
      shell = import ./nixos/services/shell.nix;
      windows = import ./nixos/services/windows.nix;
    };
  };
}
