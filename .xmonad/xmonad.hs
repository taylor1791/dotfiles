import XMonad
import XMonad.Util.EZConfig (additionalKeys, removeKeys)

main :: IO ()
main = xmonad $ defaultConfig {
    -- The default, xterm, is about as good as cmd.exe.
    terminal = "alacritty",

    -- Sometimes, with borderWidth < 2, I would lose the focused window.
    borderWidth = 2
  } `removeKeys` [
    (mod1Mask, xK_p) -- Remove dmenu for rofi
  ] `additionalKeys` [
    -- Run laucher
    ((mod1Mask, xK_p), spawn "rofi -show drun -display-drun 'Run'")
  ] 
