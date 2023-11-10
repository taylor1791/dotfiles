{
  description = "NixOS derivations supporting Taylor1791.";

  inputs = {
    alternaut-vim = {
      url = "github:PsychoLlama/alternaut.vim";
      flake = false;
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    # To incorporate https://github.com/lotabout/skim.vim/commit/aa2a5c44a6640843868cc5c1444abc0093e90e5a
    # Remove when :Files!<cr> works on stable.
    unstableVimPlugins.url = "github:NixOS/nixpkgs/b330c08616236463b873e5712c63418a2b7657e4";

    # The darwin borgBackups have been broken for some time. This is the last know
    # working revision.
    nixpkgsBorgBackup.url = "github:NixOS/nixpkgs/5e22923b8928134fb019f28dafbf89bb9953acea";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    alternaut-vim, darwin, home-manager, nixpkgs, nixpkgsBorgBackup, unstableVimPlugins, self
  }: let
    lib = nixpkgs.lib;
    profiles = import ./home/profiles.nix { inherit lib; };

    mkPkgs = nixpkgs: system:
      nixpkgs.legacyPackages.${system}.extend self.overlays.default;

    modules = [
      ./home/modules/default.nix
      ./home/presets/default.nix
    ];
  in {
    darwinConfigurations = let
      mkDarwinModules = user: module: [
        { nixpkgs.overlays = [ self.overlays.default ]; }
        home-manager.darwinModules.home-manager
        { imports = [ ./darwin/presets/default.nix ]; }
        {
          users.users.${user} = {
            name = user;
            home = "/Users/${user}";
          };

          home-manager = {
            useGlobalPkgs = true;
            users.${user} = { imports = modules; } // module;
          };
        }
      ];
    in {
      iqqkqm = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = mkDarwinModules "teverding" profiles.genericTaylor1791 ++
          [ { presets.darwin.enable = true; } ./hosts/iqqkqm ];
      };
    };

    devShell = lib.genAttrs lib.systems.flakeExposed (system:
      let pkgs = mkPkgs nixpkgs system;
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
          pkgs = mkPkgs nixpkgs system;
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
        modules =
          [ { nixpkgs.overlays = [ self.overlays.default ]; } ] ++
          (builtins.attrValues self.nixosModules) ++
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


    # Consumed by other flakes
    overlays.default = final: prev: {
      taylor1791 = {
        alternaut-vim = final.callPackage ./pkgs/alternaut-vim {
          alternautSrc = alternaut-vim;
        };
        skim = unstableVimPlugins.legacyPackages.${final.system}.vimPlugins.skim;
        skim-vim = unstableVimPlugins.legacyPackages.${final.system}.vimPlugins.skim-vim;
        bopen = final.callPackage ./pkgs/bopen {};
        borgbackup = nixpkgsBorgBackup.legacyPackages.${final.system}.borgbackup;
        color = final.callPackage ./pkgs/color {};
        mirror = final.callPackage ./pkgs/mirror {};
        rand = final.callPackage ./pkgs/rand {};
        totp = final.callPackage ./pkgs/totp {};
        warn = final.callPackage ./pkgs/warn {};
      };
    };

    # Executed by `nix build .#<name>`
    packages = lib.genAttrs lib.systems.flakeExposed (system:
      (nixpkgs.legacyPackages.${system}.extend self.overlays.default).taylor1791
    );

    templates = {
      devshell = {
        description = "A template using direnv and nix to manage a project.";
        path = ./templates/devshell;
      };
    };
  };
}
