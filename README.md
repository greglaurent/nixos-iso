# nixos-iso
Custom NixOS ISO with Install Scripts

## Build Iso
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
