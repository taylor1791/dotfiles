#!/usr/bin/env bash
set -e

function wait() {
  read -n 1 -s -r -p "Press any key to continue"
}

if [[ "$1" == "" ]]; then
  echo "Hostname not specified. Skipping hostname configuration."
else
  if [[ "$1" != "${HOSTNAME}" ]]; then
    echo "Setting hostname to $1. You may be asked for your password."
    sudo scutil --set ComputerName "$1"
    sudo scutil --set LocalHostName "$1"
    sudo scutil --set HostName "$1"
    dscacheutil -flushcache
    export HOSTNAME="$1"
  fi
fi

echo "Checking if remote login is enabled. You may be asked for your password."
if [[ $(sudo systemsetup -getremotelogin | awk '{print $3}') == "Off" ]]; then
  # If this does not work read: https://apple.stackexchange.com/questions/278744/command-line-enable-remote-login-and-remote-management
  echo "Enabling remote login."
  sudo systemsetup -setremotelogin on
fi

if [[ ! -e ~/.ssh/id_ed25519 ]]; then
  echo "Generating ssh key."
  ssh-keygen -a 256 -t ed25519
fi

if [[ ! -e ~/src ]]; then
  echo "Creating src directory."
  mkdir ~/src/
fi

PUB_KEY=$(cat ~/.ssh/id_ed25519.pub | awk '{print $2}')
if ! curl -s https://github.com/taylor1791.keys | grep -q "$PUB_KEY"; then
  cat << EOF

  Perform the following steps:
    1. Open https://github.com/settings/keys
    2. Add the following ssh key:
      $(cat ~/.ssh/id_ed25519.pub)

EOF
  wait
fi

if [[ ! -e ~/src/dotfiles ]]; then
  echo "Cloning dotfiles."
  git clone git@github.com:taylor1791/dotfiles.git
fi

if [[ ! -e ~/doc ]]; then
  echo "Creating doc directory."
  mkdir ~/doc/
fi

if [[ ! -e ~/doc/php.html ]]; then
  echo "Creating password manager."
  (cd ~/doc && nix flake init --template ~/src/dotfiles\#passhash)
  PRIVATE_KEY=$(uuidgen)
  sed -i '' "s/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/$PRIVATE_KEY/g" ~/doc/php.html
fi

MISSING_SOFTWARE=()
if ! command -v nix &> /dev/null; then
  MISSING_SOFTWARE+=("nix - https://install.determinate.systems")
fi

if ! command -v sshfs &> /dev/null; then
  MISSING_SOFTWARE+=("sshfs - https://osxfuse.github.io/")
fi

if [[ ! -d ~/Applications/Amethyst.app ]]; then
  MISSING_SOFTWARE+=("Amethyst - https://ianyh.com/amethyst/")
fi

if [[ ! -d ~/Applications/TablePlus.app ]]; then
  MISSING_SOFTWARE+=("TablePlus - https://tableplus.com/")
fi

if [[ ! -d ~/Applications/Viscosity.app ]]; then
  MISSING_SOFTWARE+=("Viscosity - https://www.sparklabs.com/viscosity/download/")
fi

if [[ ${#MISSING_SOFTWARE[@]} -gt 0 ]]; then
  echo ""
  echo "  Install the following software:"
  for SOFTWARE in "${MISSING_SOFTWARE[@]}"; do
    echo "    $SOFTWARE"
  done
  echo ""

  wait
fi

if ! command -v darwin-rebuild &> /dev/null; then
  cat << EOF

  Perform the following steps:
    1. Create a new host config in ~/src/dotfiles/hosts.
    2. Commit the new config.
    3. Activate the new config:
      nix run nix-darwin -- switch --flake ~/src/doftiles#$HOSTNAME
EOF
fi
