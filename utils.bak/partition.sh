#!/usr/bin/env bash

SWAP=$(source ./mem.sh)
DRIVE="/dev/${2:=nvme0n1}"
P1="${DRIVE}p1"
P2="${DRIVE}p2"
#P3="${DRIVE}p3"

parted "${DRIVE}" -- mklabel gpt
parted "${DRIVE}" -- mkpart ESP fat32 1MiB 512MiB
parted "${DRIVE}" -- set 1 boot on
mkfs.vfat "${P1}"

#parted "${DRIVE}" -- mkpart primary linux-swap 1GiB 9GiB
#mkswap -L Swap /dev/nvme0n1p2
#swapon /dev/nvme0n1p2

#parted /dev/nvme0n1 -- mkpart primary 
#mkfs.btrfs -L Butter /dev/nvme0n1p3

parted "${DRIVE}" -- mkpart primary 512MiB 100%
mkfs.btrfs -L PRIMARY "${P2}"

parted print

mount "${P2}" /mnt
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/etc
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/swap
btrfs subvolume create /mnt/home
umount /mnt

# tmpfs
mount -t tmpfs -o mode=755 none /mnt
mkdir -p /mnt/{boot,nix,etc,var/log,root,swap,home}

# boot
mount "${P1}" /mnt/boot

# swap
mount -o subvol=swap "${P2}" /mnt/swap
truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile
btrfs property set /mnt/swap/swapfile compression none
dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count="${SWAP}"
chmod 0600 /mnt/swap/swapfile
mkswap /mnt/swap/swapfile

# subvols
mount -o subvol=nix,space_cache=v2,compress=zstd,noatime "${P2}" /mnt/nix
mount -o subvol=etc,space_cache=v2,compress=zstd,noatime "${P2}" /mnt/etc
mount -o subvol=log,space_cache=v2,compress=zstd,noatime "${P2}" /mnt/var/log
mount -o subvol=root,space_cache=v2,compress=zstd,noatime "${P2}" /mnt/root
mount -o subvol=home,space_cache=v2,compress=zstd,noatime "${P2}" /mnt/home
