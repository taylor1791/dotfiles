{ config, lib, ... }: let
  programName = "xmobar";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's xmobar configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.xmobar = {
      enable = true;

      extraConfig = let
        colors = import ../lib/theme.nix;
      in ''
        -- All colors come from the OneDark theme. Values for --low, --normal, and
        -- --high use light red, light yellow, and white depending on threshold
        -- semantics.
        Config {
            font = "Victor Mono Bold 14",
            bgColor = "${colors.background}",
            fgColor = "${colors.text}",

            commands = [
              Run Cpu [
                "--template", "Cpu: <total>%",
                "--ppad", "2",
                "--High", "75",
                "--Low", "25",
                "--low", "${colors.text}",
                "--normal", "${colors.gold}",
                "--high", "${colors.rose}"
              ] 10,
        
              Run Memory [
                "--template", "Mem: <usedratio>%",
                "--ppad", "3",
                "--Low", "25",
                "--High", "75",
                "--low", "${colors.text}",
                "--normal", "${colors.gold}",
                "--high", "${colors.rose}"
              ] 10,
        
              Run Network "wlp0s20f3" [
                "--template", "<rx>KB|<tx>KB",
                "--width", "5",
                "--Low", "250000",
                "--High", "750000",
                "--low", "${colors.text}",
                "--normal", "${colors.gold}",
                "--high", "${colors.rose}"
              ] 10,
        
              Run Date "<fc=#61AFEF>%H:%M:%S</fc>" "time" 10,
        
              Run Battery [
               "--template", "Batt: <left>%",
                "--ppad", "3",
                "--Low", "25",
                "--High", "75",
                "--low", "${colors.rose}",
                "--normal", "${colors.gold}",
                "--high", "${colors.text}"
              ] 10,
        
              Run StdinReader
            ],
        
            template = "%StdinReader% }{ %cpu% <fc=${colors.grey_dark}>:</fc> %memory% <fc=${colors.grey_dark}>:</fc> Net: %wlp0s20f3% <fc=${colors.grey_dark}>:</fc> %battery% <fc=${colors.grey_dark}>:</fc> %time%",
          }
      '';
    };
  };
}
