{ config, lib, pkgs, ... }: let
  shell = pkgs.bashInteractive;
  shellPath = "/run/current-system/sw${shell.shellPath}";
in {
  environment.shells = [ shell ];

  # In case you forget why this is a postActivation script, read
  # https://github.com/LnL7/nix-darwin/blob/master/modules/system/activation-scripts.nix
  system.activationScripts.postActivation.text = let
    mkShellHack = user: _: ''
      CURRENT="$(dscl . -read /Users/${user} UserShell | awk '{print $2}')"
      if [[ "$CURRENT" != "${shellPath}" ]]; then
        chsh -s ${shellPath} ${user}
      fi
    '';

    mkAppsHack = user: _: let
      apps = pkgs.buildEnv {
        name = "${user}-applications";
        paths = config.home-manager.users.${user}.home.packages;
        pathsToLink = "/Applications";
      };
    in ''
      DIR="/Users/${user}/Applications/Nix Apps"
      sudo -u ${user} mkdir -p "$DIR"

      for app in $(find ${apps}/Applications -maxdepth 1 -type l); do
        name="$(basename "$app")"
        src="$(/usr/bin/stat -f%Y "$app")"
        sudo -u ${user} cp -RL "$src" "$DIR/$name"
      done
    '';
  in
    builtins.concatStringsSep "\n" (builtins.concatLists [
      # Set the user's shell even if the user already exists
      (lib.mapAttrsToList mkShellHack config.taylor1791.home.users)

      # Copy apps to ~/Applications/Nix Apps to make them appear when using Spotlight
      (lib.mapAttrsToList mkAppsHack config.taylor1791.home.users)
    ]);
}
