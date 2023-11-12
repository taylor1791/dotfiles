{ lib }: rec {
  nixosTaylor1791 = lib.recursiveUpdate genericTaylor1791 {
    presets.window-manager.enable = true;
  };

  genericTaylor1791 = lib.recursiveUpdate shellTaylor1791 {
    presets.display.enable = true;
    presets.pc.enable = true;
    presets.troubleshooting.enable = true;

    presets.development = {
      enable = true;
      email = "taylor1791@users.noreply.github.com";
      name = "Taylor Everding";
    };
  };

  shellTaylor1791 = {
    presets.shell.enable = true;
  };
}
