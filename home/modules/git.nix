{ config, lib, ... }: let
  programName = "git";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's git configuration";

    email = lib.mkOption {
      type = lib.types.str;
      description = "The email git uses in the author and committer field of commit objects";
    };

    name = lib.mkOption {
      type = lib.types.str;
      description = "The name git uses in the author and committer field of commit objects";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Taylor Everding";
      userEmail = "taylor1791@users.noreply.github.com";

      aliases = {
        "ap" = "add --patch";
        "ac" = "!git add \"$(git diff --name-only --relative --diff-filter=U)\"";
        "ca" = "commit --amend";
        "cm" = "commit --message";
        "ds" = "diff --staged";
        "lg" = "log --all --decorate --oneline --graph";
        "pushall" = "push --recurse-submodules=on-demand";
        "r" = "restore";
        "ra" = "rebase --abort";
        "rc" = "rebase --continue";
        "ri" = "rebase --interactive";
        "rs" = "restore --staged";
        "s" = "status";

        # Lost something (e.g. stash) and don't remember the hash?
        "helpme" = "!git log --graph --oneline --decorate $(git fsck --no-reflog | awk '/dangling commit/ {print $3}')";
      };

      extraConfig = {
        core.autocrlf = "input";
        difftool.prompt = false;
        help.autocorrect = 20;
        init.defaultBranch = "main";
        fetch.prune = true;
        merge.ff = false;

        pull = {
          default = "simple";
          rebase = "true";
          ff = "only";
        };
      };

      ignores = [
        # MacOS metadata
        ".DS_Store"

        # Editor config
        ".vimrc"

        # Runtime configuration
        ".envrc"
        ".env"
      ];
    };
  };
}
