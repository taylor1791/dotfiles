{ config, lib, pkgs, ... }: let
  programName = "alacritty";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's alacritty configuration";

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra settings to recursively merge into the configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.victor-mono ];

    fonts.fontconfig.enable = true;

    programs.alacritty = let
      colors = import ../lib/theme.nix;
    in {
      enable = true;

      settings = lib.recursiveUpdate {
        bell.animation = "EaseOutExpo";
        bell.duration = 25;
        bell.color = colors.purple;
        cursor.style = "Block";
        font.size = 7.0;
        font.normal.family = "Victor Mono";
        scrolling.history = 10000;
        selection.save_to_clipboard = true;

        colors = {
          cursor.text = "CellBackground";
          cursor.cursor = "CellForeground";
          draw_bold_text_with_bright_colors = false;
          primary.foreground = colors.text;
          primary.background = colors.background;
          footer_bar.background = colors.black;
          footer_bar.foreground = colors.text;

          normal = {
            black = colors.black;
            blue = colors.blue;
            cyan = colors.cyan;
            green = colors.green;
            magenta = colors.purple;
            red = colors.red;
            white = colors.white;
            yellow = colors.orange;
          };
        };

        general = {
          live_config_reload = true;
        };

        # If this is `true`, the cursor will be rendered as a hollow box when the window
        # is not focused.
        cursor.unfocused_hollow = true;

        # Allow terminal applications to change Alacritty's window title.
        window.dynamic_title = true;
      } cfg.extraSettings;
    };
  };
}
