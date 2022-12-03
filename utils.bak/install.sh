#!/usr/bin/env bash

source ./partition

nixos-generate-config --show-hardware-config

cp ./configuration.nix /etc/nixos/configuration.nix

nixos-install
