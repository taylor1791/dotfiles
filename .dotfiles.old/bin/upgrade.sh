#!/usr/bin/env bash
set -e

nix-channel --update
nix-env -u
