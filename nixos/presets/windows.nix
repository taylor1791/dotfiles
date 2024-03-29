{ config, lib, pkgs, ...}: let
  serviceName = "windows";
  cfg = config.taylor1791.presets.${serviceName};
in {
  options.taylor1791.presets.${serviceName} = {
    enable = lib.mkEnableOption "Configures systems using a window manager.";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.taylor1791.presets.shell.enable;
        message = "Display managers requires a shell. Set taylor1791.shell.enabled = true";
      }
    ];

    hardware.bluetooth.enable = true;
    hardware.pulseaudio.enable = true;
    networking.networkmanager.enable = true;
    programs.light.enable = true;
    services.devmon.enable = true;
    services.hardware.bolt.enable = true;
    sound.enable = true;
    time.timeZone = "America/Denver";

    # Allow emulating aarch64-linux for cross-compiling raspberry pi images.
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    environment.systemPackages = with pkgs; [
      brightnessctl
      firefox
      xclip
    ];

    services.xserver = {
      enable = true;

      autoRepeatDelay = 250;
      autoRepeatInterval = 32;
      layout = "us";
      xkbOptions = "caps:escape";

      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+xmonad";
      };

      libinput = {
        enable = true;
        touchpad.accelProfile = "adaptive";
      };

      windowManager = {
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
        xmonad.extraPackages = hpkgs: [
          hpkgs.xmonad
          hpkgs.xmonad-contrib
          hpkgs.xmonad-extras
        ];
      };
    };
  };
}
