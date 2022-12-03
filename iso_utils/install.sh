#!/usr/bin/env bash

source ./partition.sh

nixos-generate-config --root /mnt

cp /etc/iso_utils/configuration.nix.bak /mnt/etc/nixos/configuration.nix

(cd /mnt; nixos-install)
