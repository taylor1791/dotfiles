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
      extraPackages = haskellPackages: [ haskellPackages.X11 haskellPackages.directory ];

      config = let
        colors = import ../lib/theme.nix;
      in pkgs.writeText "xmonad.hs" ''
        import XMonad
        import XMonad.Hooks.DynamicLog
        import XMonad.Util.EZConfig (additionalKeys, removeKeys)
        import Graphics.X11.ExtraTypes.XF86
        import System.Directory (listDirectory)
        import Data.List (find, isPrefixOf)
        import Control.Exception (try, SomeException)
        
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


        -- Read battery level from /sys/class/power_supply, returns 100 if no battery.
        getBatteryLevel :: IO Int
        getBatteryLevel = do
          let dir = "/sys/class/power_supply"
          result <- try $ do
            entries <- listDirectory dir
            case find ("BAT" `isPrefixOf`) entries of
              Just bat -> read . filter (/= '\n') <$> readFile (dir ++ "/" ++ bat ++ "/capacity")
              Nothing -> return 100
          return $ either (\(_ :: SomeException) -> 100) id result


        -- Select border color based on battery level.
        batteryBorderColor :: Int -> String
        batteryBorderColor level
          | level < 5  = "${colors.red}"
          | level < 15 = "${colors.orange}"
          | otherwise  = "${colors.purple}"


        -- Update focused window border based on battery level.
        batteryLogHook :: X ()
        batteryLogHook = do
          level <- liftIO getBatteryLevel
          let color = batteryBorderColor level
          dpy <- asks display
          colorPixel <- liftIO $ initColor dpy color
          case colorPixel of
            Just pixel -> withFocused $ \w -> liftIO $ setWindowBorder dpy w pixel
            Nothing -> return ()


        -- The configuration for xmonad. Normally I would write the type signature, but
        -- the signature encodes all of the layouts. Neat, I think....
        xmonadConfig = def {
            -- The default, xterm, is about as good as cmd.exe.
            terminal = "alacritty",
        
            -- Sometimes, with borderWidth < 2, I would lose the focused window.
            borderWidth = 2,
        
            -- OneDark Theme
            focusedBorderColor = "${colors.purple}",
            normalBorderColor  = "${colors.black}",

            -- Update border color based on battery level
            logHook = batteryLogHook
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
            ((noModMask, xF86XK_AudioLowerVolume), spawn "amixer set Master 5%-"),
            ((noModMask, xF86XK_AudioRaiseVolume), spawn "amixer set Master 5%+"),
            ((noModMask, xF86XK_AudioMicMute), spawn "amixer set Capture toggle"),
            ((noModMask, xF86XK_MonBrightnessDown), spawn "brightnessctl s 10%-"),
            ((noModMask, xF86XK_MonBrightnessUp), spawn "brightnessctl s 10%+")
          ]
      '';
    };
  };
}
