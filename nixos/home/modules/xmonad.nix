{ config, lib, pkgs, ... }: let
  programName = "xmonad";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's xmonad configuration";
  };

  config = lib.mkIf cfg.enable {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [ haskellPackages.X11 ];

      config = let
        colors = import ../lib/theme.nix;
      in pkgs.writeText "xmonad.hs" ''
        import XMonad
        import XMonad.Hooks.DynamicLog
        import XMonad.Util.EZConfig (additionalKeys, removeKeys)
        import Graphics.X11.ExtraTypes.XF86
        
        main :: IO ()
        main = do
          xmonad =<<
            statusBar "xmobar" xmonadBar toggleKey xmonadConfig
        
        
        -- Contents of XMonad portion of xmobar.
        xmonadBar :: PP
        xmonadBar = xmobarPP {
          ppCurrent = xmobarColor "${colors.purple}" "" . wrap "[" "]",
          ppSep = xmobarColor "${colors.grey_dark}" "" " : ",
          ppTitle = xmobarColor "${colors.purple}" ""
        }
        
        
        -- Keybinding to toggle XMonad covering the status bar.
        toggleKey :: XConfig Layout -> (KeyMask, KeySym)
        toggleKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
        
        
        -- The configuration for xmonad. Normally I would write the type signature, but
        -- the signature encodes all of the layouts. Neat, I think....
        xmonadConfig = def {
            -- The default, xterm, is about as good as cmd.exe.
            terminal = "alacritty",
        
            -- Sometimes, with borderWidth < 2, I would lose the focused window.
            borderWidth = 2,
        
            -- OneDark Theme
            focusedBorderColor = "${colors.purple}",
            normalBorderColor  = "${colors.black}"
          } `removeKeys` [
              (mod1Mask, xK_p) -- Remove dmenu for rofi
            , (shiftMask .|. mod1Mask, xK_p) -- Remove dmrun for rofi-calc
          ] `additionalKeys` [
            -- Run laucher
            ((mod1Mask, xK_p), spawn "rofi -show drun -display-drun 'Run: '"),
        
            -- Calculator
            ((shiftMask .|. mod1Mask, xK_p), spawn "rofi -show calc -display-calc 'QCalc: '"),
        
            -- Emoji picker
            ((controlMask .|. mod1Mask, xK_space), spawn "rofi -show emoji"),
        
            -- "F keys"
            ((noModMask, xF86XK_AudioMute), spawn "amixer set Master toggle"),
            ((noModMask, xF86XK_AudioLowerVolume), spawn "amixer set Master 10%-"),
            ((noModMask, xF86XK_AudioRaiseVolume), spawn "amixer set Master 10%+"),
            ((noModMask, xF86XK_AudioMicMute), spawn "amixer set Capture toggle"),
            ((noModMask, xF86XK_MonBrightnessDown), spawn "brightnessctl s 10%-"),
            ((noModMask, xF86XK_MonBrightnessUp), spawn "brightnessctl s 10%+")
          ]
      '';
    };
  };
}
