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
    system.defaults.spaces.spans-displays = true;

    system.defaults.CustomSystemPreferences = {
      "com.apple.Safari" = {
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };

      "com.apple.WindowManager" = {
        AppWindowGroupingBehavior = 1;
        AutoHide = 0;
        EnableStandardClickToShowDesktop = 0;
        HasDisplayedShowDesktopEducation = 1;
        HideDesktop = 1;
        StageManagerHideWidgets = 0;
        StandardHideDesktopIcons = 0;
        StandardHideWidgets = 0;
      };
    };

    system.defaults.CustomUserPreferences = {
    };

    system.activationScripts.extraUserActivation = {
      enable = true;
      text = let
        keys = {
           "118" = [ "49" "18" "524288" ];
           "119" = [ "50" "19" "524288" ];
           "120" = [ "51" "20" "524288" ];
           "121" = [ "52" "21" "524288" ];
           "122" = [ "53" "23" "524288" ];
           "123" = [ "54" "22" "524288" ];
           "124" = [ "55" "26" "524288" ];
           "125" = [ "56" "28" "524288" ];
           "126" = [ "57" "25" "524288" ];
           "127" = [ "48" "29" "524288" ];
         };

        commands = lib.mapAttrsToList (key: keys: ''
          defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${key} '
            <dict>
              <key>enabled</key>
              <true/>
              <key>value</key>
              <dict>
                <key>parameters</key>
                <array>
                  <integer>${builtins.toString (builtins.elemAt keys 0)}</integer>
                  <integer>${builtins.toString (builtins.elemAt keys 1)}</integer>
                  <integer>${builtins.toString (builtins.elemAt keys 2)}</integer>
                </array>
                <key>type</key>
                <string>standard</string>
              </dict>
            </dict>'
        '') keys;
      in lib.mkForce ''
        echo "configuring hotkeys..."
        ${builtins.concatStringsSep "\n" commands}
      '';
    };
  };
}
