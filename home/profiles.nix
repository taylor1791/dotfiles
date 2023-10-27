{ lib }: rec {
  nixosTaylor1791 = lib.recursiveUpdate genericTaylor1791 {};

  genericTaylor1791 = {
    presets.development = {
      enable = true;
    };
  };
}
