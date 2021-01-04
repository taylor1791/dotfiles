import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeys, removeKeys)

main :: IO ()
main = do
  xmonad =<<
    statusBar "xmobar" xmonadBar toggleKey xmonadConfig


-- Contents of XMonad portion of xmobar.
xmonadBar :: PP
xmonadBar = xmobarPP {
  ppCurrent = xmobarColor "#C678DD" "" . wrap "[" "]",
  ppSep = xmobarColor "#5C6370" "" " : ",
  ppTitle = xmobarColor "#C678DD" ""
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
    focusedBorderColor = "#C678DD", -- Magenta
    normalBorderColor  = "#4B5263"  -- Gutter Grey
  } `removeKeys` [
    (mod1Mask, xK_p) -- Remove dmenu for rofi
  ] `additionalKeys` [
    -- Run laucher
    ((mod1Mask, xK_p), spawn "rofi -show drun -display-drun 'Run: '")
  ] 
