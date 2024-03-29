{ lib }: {
  development = {
    enable = lib.mkEnableOption "Enable developer tools";

    email = lib.mkOption {
      type = lib.types.str;
      description = "The email git uses in the author and committer field of commit objects";
    };

    name = lib.mkOption {
      type = lib.types.str;
      description = "The name git uses in the author and committer field of commit objects";
    };
  };

  display = {
    enable = lib.mkEnableOption "Enable dotfiles for systems with a display";
  };

  pc = {
    enable = lib.mkEnableOption "Enable dotfiles for a single user personal computer";
  };

  shell = {
    enable = lib.mkEnableOption "Enable dotfiles for routine shell access";
  };

  troubleshooting = {
    enable = lib.mkEnableOption "Enable troubleshooting tools";
  };

  window-manager = {
    enable = lib.mkEnableOption "Enable dotfile for systems with window mangers";
  };
}
