{ lib }: rec {
  nixosTaylor1791 = lib.recursiveUpdate genericTaylor1791 {
    presets.window-manager.enable = true;
  };

  genericTaylor1791 = {
    presets.display.enable = true;
    presets.pc.enable = true;
    presets.shell.enable = true;
    presets.troubleshooting.enable = true;

    presets.development = {
      enable = true;
      email = "taylor1791@users.noreply.github.com";
      name = "Taylor Everding";
    };
  };
}
