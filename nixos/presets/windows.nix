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
    services.pipewire.enable = false;
    time.timeZone = "America/Denver";

    # Allow emulating aarch64-linux for cross-compiling raspberry pi images.
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    environment.systemPackages = with pkgs; [
      alsa-utils
      brightnessctl
      firefox
      xclip
    ];

    services.displayManager = {
      defaultSession = "none+xmonad";
    };

    services.libinput = {
      enable = true;
      touchpad.accelProfile = "adaptive";
    };

    services.xserver = {
      enable = true;

      autoRepeatDelay = 250;
      autoRepeatInterval = 32;

      displayManager = {
        lightdm.enable = true;
      };

      xkb = {
        options = "caps:escape";
        layout = "us";
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
