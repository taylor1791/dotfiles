#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

mkdir ~/.dotfiles
cp -R ./* ~/.dotfiles/
bash -xe ~/.dotfiles/setup.sh
bash -xe ~/.bash_profile
