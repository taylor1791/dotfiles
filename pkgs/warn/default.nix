{ pkgs, writeShellApplication, ... }: writeShellApplication {
  name = "warn";
  runtimeInputs = [ pkgs.ncurses ];

  text = ''
    # Different terminals use different escape codes. E.g. iTerm does not support
    # ANSI color codes. E.g. `xTerm` only supports ANSI color codes. Using `tput`
    # is as cross-platform as it comes.
    if command -v tput > /dev/null; then
      tput bold
      tput setaf 3
      echo "''${@}" >&2
      tput sgr0
    else
      echo -e "''${@}" >&2
    fi
  '';
}
