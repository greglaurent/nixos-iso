{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ 
    "vfat" 
    "fat32" 
    "btrfs" 
    "ext" 
    "ntfs" 
    "ecryptfs" 
  ];
  environment = { 
    systemPackages = with pkgs; [ git vim wget lsof ];
    etc = { 
      "iso_utils/install.sh" = {
        source = ./iso_utils/install.sh;
        mode = "0700";
      };
      "iso_utils/partition.sh" = {
        source = ./iso_utils/partition.sh;
        mode = "0700";
      };
      "iso_utils/mem.sh" = {
        source = ./iso_utils/mem.sh;
        mode = "0700";
      };
      "iso_utils/configuration.nix.bak" = { source = ./iso_utils/configuration.nix.bak; };
    };
  };

  environment.variables = { PATH = [ "/bin" "/usr/bin" "etc/iso_utils" ]; };
}
