#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

cd $HOME
mv build/taylor1791/dotfiles .dotfiles
bash -xe ./.dotfiles/setup.sh
bash -xe .bash_profile

