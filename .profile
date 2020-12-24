# When invoking a shell with --login, the shell sources this file. E.g. Logging
# into a tty, desktop environment, remote shell (ssh or rsh), or any shell on
# MacOS.

# Login shells never source .bashrc. By sourcing .bashrc here, interactive
# login shells can use definitions in .bashrc.
# Note: To detect if the shell is interactive, the third condition compares
# the shell flags to a version with the shortest string ending in i removed.
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && [ "$-" != "${-#*i}" ]; then
  source "$HOME/.bashrc"
fi

# To support different platforms uniformly, all platforms must use the same
# package manager. I choose you, Nix!
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  . ~/.nix-profile/etc/profile.d/nix.sh;
fi
