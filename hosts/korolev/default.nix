{ lib, modulesPath, pkgs, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "korolev";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  services.libinput.touchpad.accelSpeed = "0.60";
  system.stateVersion = "20.09";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8028db26-1ac1-4c8e-a059-4ef4c8338e9d";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/E71F-0CF0";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/9e80fcbf-c368-4d9a-964b-3b7b36c59558";
      fsType = "ext4";
    };
  };

  taylor1791.home = {
    profiles.taylor1791.nixos.enable = true;
    users.taylor1791.stateVersion = "23.05";
  };

  taylor1791.presets = {
    console = { enable = true; };
    development = { enable = true; };
    shell = { enable = true; };
    windows = { enable = true; };
  };

  services.borgbackup = {
    jobs = {
      korolev = {
        repo = "korolev@prd-nas-000.idagalaxy.com:.";
        startAt = "0:00";
        group = "users";
        persistentTimer = true;
        user = "taylor1791";
        preHook = ''
          if [ ! -f /run/keys/borg ]; then
            ${pkgs.taylor1791.unotify}/bin/unotify add "Backup key not available. Run 'secrets pull'." -s backup -k backup-key-missing -p
            exit 1
          fi
          echo "Waiting for network to come up"
          until ${pkgs.iputils}/bin/ping prd-nas-000.idagalaxy.com -c1 -q; do sleep 1; done
          echo "Network is up"
        '';
        compression = "zstd";
        paths = [ "/home/taylor1791" ];
        exclude = [ "/home/taylor1791/.cache" "**/node_modules" "**/target" ];
        prune.keep = { daily = 7; weekly = 4; monthly = 12; yearly = 10; };
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /run/keys/borg";
        };
        environment = {
          BORG_RSH = "ssh -i /home/taylor1791/.ssh/borg";
          BORG_RELOCATED_REPO_ACCESS_IS_OK="yes";
        };
      };
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/4abdec35-bad4-4c14-9004-3b62f958a8e4"; }
  ];

  systemd.services.idagalaxy-cert-check = {
    description = "Check SSL certificate expiration for vault.idagalaxy.com";
    serviceConfig = {
      Type = "oneshot";
      User = "taylor1791";
      Group = "users";
    };
    script = ''
      DOMAIN="vault.idagalaxy.com"
      PORT=443
      WARN_DAYS=13

      EXPIRY=$(${pkgs.openssl}/bin/openssl s_client \
        -connect "$DOMAIN:$PORT" \
        -servername "$DOMAIN" \
        </dev/null 2>/dev/null \
        | ${pkgs.openssl}/bin/openssl x509 -noout -enddate \
        | cut -d= -f2)

      if [ -z "$EXPIRY" ]; then
        ${pkgs.taylor1791.unotify}/bin/unotify add "Could not retrieve SSL certificate" \
          -s vault-cert -k vault-cert-error -p
        exit 1
      fi

      EXPIRY_EPOCH=$(${pkgs.coreutils}/bin/date -d "$EXPIRY" +%s)
      NOW_EPOCH=$(${pkgs.coreutils}/bin/date +%s)
      DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

      if [ "$DAYS_LEFT" -le "$WARN_DAYS" ]; then
        ${pkgs.taylor1791.unotify}/bin/unotify add "SSL cert expires in $DAYS_LEFT days" \
          -s vault-cert -k vault-cert-expiry -p
      fi
    '';
  };

  systemd.timers.idagalaxy-cert-check = {
    description = "Timer for SSL certificate expiration check";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
