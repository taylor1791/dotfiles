#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

install_z() {
  git clone https://github.com/rupa/z.git --depth 1
  pushd z
  chmod +x z.sh

  sudo mkdir -p /usr/local/etc/profile.d
  sudo cp z.sh /usr/local/etc/profile.d/

  sudo mkdir -p /usr/local/share/man/man1/
  sudo cp z.1 /usr/local/share/man/man1/
  sudo mandb --quiet
  popd
  rm -rf z
}

install() {
  NAME="$1"

  echo "Installing $NAME..."

  if [[ "$NAME" == "z" ]]; then
    install_z
  elif [[ "$NAME" == "fnm" ]]; then
    curl -L -O https://github.com/Schniz/fnm/releases/download/v1.2.1/fnm-linux.zip
    unzip -j fnm-linux.zip -d ~/.bin/
    chmod +x ~/.bin/fnm
    rm fnm-linux.zip
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
