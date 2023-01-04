# Defines the system. For help, read the configuration.nix(5) man page.
{ pkgs, ... }: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    # package = unstable.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings.trusted-users = [ "taylor1791" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "korolev";

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  # FIXME use console.XkbConfig = true;

  # Display, Desktop, and Window Management
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager = {
    xmonad.enable = true;
    xmonad.enableContribAndExtras = true;
    xmonad.extraPackages = hpkgs: [
      hpkgs.xmonad
      hpkgs.xmonad-contrib
      hpkgs.xmonad-extras
    ];
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:escape";
  services.xserver.autoRepeatDelay = 250;
  services.xserver.autoRepeatInterval = 32;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.touchpad.accelProfile = "adaptive";
  services.xserver.libinput.touchpad.accelSpeed = "0.60";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account.
  users.users.taylor1791 = {
    isNormalUser = true;
    extraGroups = [ "docker" "networkmanager" "taylor1791" "video" "wheel" ];
  };

  # Packages installed in the system profile. This minimal list should be
  # supplemented by a user profile.
  environment.systemPackages = with pkgs; [
    # Devices
    brightnessctl
    zsa-udev-rules

    # Development
    git
    vim

    # Desktop 
    firefox
    (rofi.override { plugins = [ rofi-calc rofi-emoji ]; })
    xclip
    xmobar
  ];

  # List services that you want to enable:
  services.devmon.enable = true;
  services.lorri.enable = true;
  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  # Global program settings
  programs.ssh.startAgent = true;
  programs.light.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  fonts.fonts = with pkgs; [
    mononoki
  ];
}
