#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

install() {
  NAME="$1"

  echo "Installing $NAME..."

  if [[ "$NAME" == "fnm" ]]; then
    curl -L -O https://github.com/Schniz/fnm/releases/download/v1.2.1/fnm-linux.zip
    unzip -j fnm-linux.zip -d ~/.bin/
    chmod +x ~/.bin/fnm
    rm fnm-linux.zip
  elif [[ "$NAME" == "ripgrep" ]]; then
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
    sudo dpkg -i ripgrep_0.10.0_amd64.deb
    rm -rf ripgrep_0.10.0_amd64.deb
  else
    sudo apt-get install -y "$NAME"
  fi
}

setup_neovim() {
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y python-software-properties
  sudo add-apt-repository ppa:jonathonf/vim
  sudo apt-get update
}

setup_neovim
install unzip
