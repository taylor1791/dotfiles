{ config, lib, ... }: let
  programName = "bash";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's bash configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      historyIgnore = [ "cd" "fg" "ls" ];

      bashrcExtra = ''
        # Normally, bash sources this file if the shell is interactive and non-login.
        # However, .profile will look for this file and source it, effectively making it
        # run for all interactive shells! Additionally, bash sources this file when
        # attached to a remote shell, e.g. ssh and rsh.

        # This file is sourced by bash during ssh. If this file prints anything to
        # standard out during the rcp, scp, or sftp protocols, it will interrupt the
        # protocol and fail the transfer. By exiting in non-interactive shells, this
        # cannot happen.
        [[ $- != *i* ]] && return

        # Instructs man to use an alternate pager.
        export MANPAGER="nvim +Man!";

        # Something better than the default.
        export PS1="\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] "

        # Support the committed innovators.
        if command -v nvim > /dev/null; then
          alias vim=nvim
        fi

        # Easier: `open`. Harder: `xdg-open`.
        if ! command -v open > /dev/null; then
          alias open="xdg-open"
        fi

        # Turn on direnv to autoconfigure development environments.
        if command -v direnv > /dev/null; then
          eval "$(direnv hook bash)"
        fi
        
        # Turn on "z" for fast navigation.
        if command -v zoxide > /dev/null; then
          eval "$(zoxide init bash)"
        fi

        # Source any "local" machine specific configuration.
        LOCAL_BASHRC="$HOME/.bashrc.local"
        [[ -f "$LOCAL_BASHRC" ]] && source "$LOCAL_BASHRC"
      '';

      # Do not save commands that start with space to history.
      historyControl = [ "ignorespace" ];

      profileExtra = ''
        # When invoking a shell with --login, the shell sources this file. E.g. Logging
        # into a tty, desktop environment, remote shell (ssh or rsh), or any shell on
        # MacOS.
        
        # Login shells never source .bashrc. By sourcing .bashrc here, interactive
        # login shells can use definitions in .bashrc.
        # Note: To detect if the shell is interactive, the third condition compares
        # the shell flags to a version with the shortest string ending in i removed.
        if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && [ "$-" != "''${-#*i}" ]; then
          source "$HOME/.bashrc"
        fi
      '';
    };
  };
}
