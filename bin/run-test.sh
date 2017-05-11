#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then 
  bash -x bin/test.sh;
fi

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
  DIR="build/taylor1791/dotfiles"
  docker run \
    -v `pwd`:/root/$DIR \
    -w /root/$DIR \
    -e "TRAVIS_OS_NAME=$TRAVIS_OS_NAME" \
    ubuntu:16.04 \
    bash -x /root/$DIR/bin/test.sh
fi

