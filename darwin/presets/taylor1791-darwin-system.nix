{ config, lib, pkgs, ... }: let
  presetName = "taylor1791DarwinSystem";
  cfg = config.taylor1791.presets.${presetName};
in {
  options = {
    taylor1791.presets.${presetName} = {
      enable = lib.mkEnableOption "Configure Darwin specific configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    system.defaults.LaunchServices.LSQuarantine = false;
    system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;
    system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 0.9375;
    system.defaults.NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;
    system.defaults.NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;
    system.defaults.NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;
    system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
    system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
    system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
    system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
    system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
    system.defaults.NSGlobalDomain.KeyRepeat = 2;
    system.defaults.NSGlobalDomain.NSDisableAutomaticTermination = true;
    system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    system.defaults.NSGlobalDomain.NSTextShowsControlCharacters = true;
    system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
    system.defaults.dock.autohide = true;
    system.defaults.dock.mru-spaces = false;
    system.defaults.dock.static-only = true;
    system.defaults.finder.AppleShowAllFiles = true;
    system.defaults.finder.FXEnableExtensionChangeWarning = false;
    system.defaults.finder.FXPreferredViewStyle = "Nlsv";
    system.defaults.finder.QuitMenuItem = true;
    system.defaults.finder.ShowStatusBar = true;
    system.defaults.finder._FXShowPosixPathInTitle = true;
    system.defaults.loginwindow.GuestEnabled = false;
    system.defaults.loginwindow.SHOWFULLNAME = true;
    system.defaults.menuExtraClock.Show24Hour = true;
    system.defaults.screensaver.askForPassword = true;
    system.defaults.screensaver.askForPasswordDelay = 60;
    system.keyboard.remapCapsLockToEscape = true;

    system.defaults.CustomSystemPreferences = {
      "com.apple.Safari" = {
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };
    };

    system.defaults.CustomUserPreferences = {
    };
  };
}
