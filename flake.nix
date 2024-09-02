{
  description = "NixOS derivations supporting Taylor1791.";

  inputs = {
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # The darwin borgBackups have been broken for some time. This is the last know
    # working revision.
    nixpkgsBorgBackup.url = "github:NixOS/nixpkgs/5e22923b8928134fb019f28dafbf89bb9953acea";
  };

  outputs = {
    darwin, home-manager, nixpkgs, nixpkgsBorgBackup, self
  }: let
    lib = nixpkgs.lib;

    nixpkgsConfig = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "copilot.vim"
      ];
    };

    mkPkgs = nixpkgs: system: import nixpkgs {
      inherit system;

      overlays = [ self.overlays.default ];

      config = nixpkgsConfig;
    };
  in {
    darwinConfigurations = let
      darwinModules = [
        { nixpkgs.config = nixpkgsConfig; nixpkgs.overlays = [ self.overlays.default ]; }
        home-manager.darwinModules.home-manager
      ] ++ (lib.attrsets.collect (v: !lib.isAttrs v) self.darwinModules);
    in {
      apollo = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = darwinModules ++ [ ./hosts/apollo ];
      };
    };

    darwinModules = {
      home = import ./nixos/home/default.nix;
      taylor1791DarwinSystem = import ./darwin/presets/taylor1791-darwin-system.nix;
      users = import ./nixos/users/default.nix;
    };

    devShell = lib.genAttrs lib.systems.flakeExposed (system:
      let pkgs = mkPkgs nixpkgs system;
      in pkgs.mkShell {
        buildInputs = with pkgs; [ just nix-diff ];
      }
    );

    nixosConfigurations = let
      nixosModules = [
        { nixpkgs.config = nixpkgsConfig; nixpkgs.overlays = [ self.overlays.default ]; }
        home-manager.nixosModules.home-manager
      ] ++ (lib.attrsets.collect (v: !lib.isAttrs v) self.nixosModules);
    in {
      korolev = lib.nixosSystem {
        system = "x86_64-linux";
        modules = nixosModules ++ [ ./hosts/korolev ];
      };
    };

    nixosModules = {
      console = import ./nixos/presets/console.nix;
      development = import ./nixos/presets/development.nix;
      home = import ./nixos/home/default.nix;
      shell = import ./nixos/presets/shell.nix;
      users = import ./nixos/users/default.nix;
      windows = import ./nixos/presets/windows.nix;
    };

    # Consumed by other flakes
    overlays.default = final: prev: {
      taylor1791 = {
        backup = final.callPackage ./pkgs/backup {};
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

    # Consumed by `nix flake init github:taylor1791/dotfiles#<name>`
    templates = {
      devshell = {
        description = "A template using direnv and nix to manage a project.";
        path = ./templates/devshell;
      };

      passhash = {
        description = "A template for generating passwords.";
        path = ./templates/passhash;
      };
    };
  };
}
