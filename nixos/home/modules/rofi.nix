{ config, lib, pkgs, ... }: let
  programName = "rofi";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's rofi configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.mononoki ];

    programs.rofi = let
      colors = import ../lib/theme.nix;
    in {
      enable = true;
      package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ]; };

      extraConfig = let
        extra = { modi = "calc,drun,emoji"; };

        terminal = lib.optionalAttrs
          config.taylor1791.programs.alacritty.enable
          { terminal = "alacritty"; };
      in extra // terminal;

      # See `man rofi-theme` for details.
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        # Global properties. Every element inherits these properties.
        "*" = {
          black = mkLiteral colors.background;
          blue = mkLiteral colors.blue;
          comment-grey = mkLiteral colors.grey_dark;
          cyan = mkLiteral colors.cyan;
          green = mkLiteral colors.green;
          gutter-grey = mkLiteral colors.black;
          magenta = mkLiteral colors.purple;
          red = mkLiteral colors.rose;
          white = mkLiteral colors.text;
          yellow = mkLiteral colors.gold;

          # Derived-colors
          white10 = mkLiteral (colors.text + "0A");

          background-color = mkLiteral "@black";
          font = "mononoki 16";
          text-color = mkLiteral "@white";
        };

        window = {
          border-color = mkLiteral "@blue";
          border = 2;
        };

        inputbar = {
          "padding" = mkLiteral "0.25em";
          "border" = mkLiteral "0 dash 0 dash 2px dash 0 dash";
          "border-color" = mkLiteral "@gutter-grey";
        };

        # To test an error message, use the following command:
        # $ rofi -e "Hello World"
        error-message = {
          background-color = mkLiteral "@magenta";
          text-color = mkLiteral "@black";
          padding = mkLiteral "1em";
        };

        textbox = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        # To test a message, use the following command:
        # $ echo 'a:b:c' | rofi -sep : -dmenu -mesg 'Choose an option:'
        message = {
          padding = mkLiteral "0.25em";
        };

        # It is hard not to test this with any rofi command. Example:
        # $ rofi -show drun
        listview = {
          background-color = mkLiteral "@black";
          scrollbar = true;
        };

        scrollbar = {
          handle-width = mkLiteral "0.5em";
          handle-color = mkLiteral "@gutter-grey";
        };

        element-text = {
          padding = mkLiteral "0.125em";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "      inherit";
        };

        "element.alternate.normal, element.alternate.active, element.alternate.urgent" = {
          background-color = mkLiteral "@white10";
        };

        # To test active states, run these commands:
        # $ echo 'a:b:c:d' | rofi -sep ':' -dmenu -a 2
        # $ echo 'a:b:c:d' | rofi -sep ':' -dmenu -a 3
        "element.normal.active, element.alternate.active" = {
          text-color = mkLiteral "@blue";
        };

        # To test active states, run this command:
        # $ echo 'a:b:c:d' | rofi -sep ':' -dmenu -u 2-3
        "element.normal.urgent, element.alternate.urgent" = {
          text-color = mkLiteral "@red";
        };

        # To test the selected states, run this command:
        # $ echo 'a,b,c,d' | rofi -sep , -dmenu -a 2 -u 3
        "element.selected.normal, element.selected.active, element.selected.urgent" = {
          text-color = mkLiteral "@black";
        };

        "element.selected.normal" = {
          background-color = mkLiteral "@white";
        };

        "element.selected.active" = {
          background-color = mkLiteral "@blue";
        };

        "element.selected.urgent" = {
          background-color = mkLiteral "@red";
        };

        # I don't use the mode switcher; it is left unstyled.
      };
    };
  };
}
