# Normally, bash sources this file if the shell is interactive and non-login.
# However, .profile will look for this file and source it, effectivly making it
# run for all interactive shells! Additionally, bash sources this file when
# attached to a remote shell, e.g. ssh and rsh.

# Include the user's private bin directory, if they have one.
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# This file is sourced by bash during ssh. If this file prints anything to
# standard out during the rcp, scp, or sftp protocols, it will interrupt the
# protocol and fail the transfer. By exiting in non-interactive shells, this
# cannot happen.
[[ $- != *i* ]] && return

# Many applications delegate to this when editing a file. Bash command line
# editing is one example.
export EDITOR=vim

# Easier: `open`. Harder: `xdg-open`.
if ! command -v open > /dev/null; then
  alias open="xdg-open"
fi

# Inform the user of required manual tasks.
dotfiles status
