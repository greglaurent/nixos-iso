#!/usr/bin/env bash

export NIXPKGS_ALLOW_BROKEN=1

nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=./iso.nix
