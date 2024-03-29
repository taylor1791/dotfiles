{ config, lib, pkgs, ... }: let
  programName = "zathura";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's alacritty configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.mononoki ];

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };

    programs.zathura = let
      colors = import ../lib/theme.nix;
    in {
      enable = true;

      # A configuration file for zathura. See `man zathurarc` for more details.
      options = {
        font = "mononoki 13";

        # Use clipboard instead of primary.
        selection-clipboard = "clipboard";

        # Only show the basename in the statusbar.
        statusbar-basename = true;

        # Replace $HOME with ~ in the window title.
        window-title-home-tilde = true;

        # Theme
        default-bg = colors.background;
        default-fg = colors.text;
        statusbar-bg = colors.bar;
        statusbar-fg = colors.text;
        inputbar-bg = colors.background;
        inputbar-fg = colors.text;

        # To test, use tab completion. E.g :open <TAB>
        completion-bg = colors.bar;
        completion-fg = colors.text;
        completion-group-bg = colors.bar;
        completion-group-fg = colors.text;
        completion-highlight-fg = colors.bar;
        completion-highlight-bg = colors.blue;
        
        render-loading-bg = colors.bar;
        render-loading-fg = colors.blue;
        
        # To test, search for text
        highlight-color = colors.blue;
        highlight-active-color = colors.purple;
        
        # To test, open the index with <TAB>.
        index-bg = colors.background;
        index-fg = colors.text;
        index-active-bg = colors.blue;
        index-active-fg = colors.bar;
        
        # To test, select some text with the mouse.
        notification-bg = colors.green;
        notification-fg = colors.background;
        
        notification-warning-bg = colors.gold;
        notification-warning-fg = colors.background;
        
        # To test, set an unkown option. E.g :set chicken fried
        notification-error-bg = colors.rose;
        notification-error-fg = colors.background;
        
        # Recolor the pdfs to match OneDark. Impressive.
        recolor = true;
        recolor-keephue = true;
        recolor-darkcolor = colors.text;
        recolor-lightcolor = colors.background;
      };
    };
  };
}
