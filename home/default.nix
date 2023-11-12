{ config, lib, pkgs, ... }: let
  moduleName = "home";
  cfg = config.taylor1791.${moduleName};
  presetOptions = import ./presets/options.nix { inherit lib; };

  mkPresetOption = options: lib.mkOption {
    default = { enable = false; };
    type = lib.types.submodule { inherit options; };
  };
in {
  options.taylor1791.${moduleName} = {
    users = lib.mkOption {
      default = {};

      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          presets = lib.mkOption {
            default = {};

            type = lib.types.submodule {
              options = {
                development = mkPresetOption presetOptions.development;
                display = mkPresetOption presetOptions.display;
                pc = mkPresetOption presetOptions.pc;
                shell = mkPresetOption presetOptions.shell;
                troubleshooting = mkPresetOption presetOptions.troubleshooting;
                window-manager = mkPresetOption presetOptions.window-manager;
              };
            };
          };

          stateVersion = lib.mkOption {
            type = lib.types.str;
          };
        };
      });
    };
  };

  config = {
    home-manager = let
      mkUser = name: { presets, stateVersion }: {
        inherit presets;

        imports = [ ./modules/default.nix ./presets/default.nix ];
        home.stateVersion = stateVersion;
      };
    in {
      # Use nixpkgs from nixos
      useGlobalPkgs = true;
      users = builtins.mapAttrs mkUser cfg.users;
    };

    nix.settings.trusted-users = builtins.attrNames cfg.users;

    users.users = let
      mkDarwinUser = user: _: {
        name = user;
        home = "/Users/${user}";
      };

      mkNixosUser = user: _: {
        isNormalUser = true;
        extraGroups = [ "keys" "wheel" ] ++
          lib.optionals config.taylor1791.presets.development.enable ["docker"] ++
          lib.optionals config.taylor1791.presets.windows.enable ["networkmanager" "video"]
        ;
      };

      mkUser = if pkgs.stdenv.isDarwin then mkDarwinUser else mkNixosUser;
    in builtins.mapAttrs mkUser cfg.users;
  };
}
