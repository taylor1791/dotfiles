#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# OS Specific test setup
. bin/test.$TRAVIS_OS_NAME.sh

cd $HOME
cp -R build/taylor1791/dotfiles .dotfiles
bash -xe ./.dotfiles/setup.sh
bash -xe .bash_profile

