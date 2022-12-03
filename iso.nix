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
    systemPackages = with pkgs; [ git vim wget ];
    etc = { 
      "utils/install.sh" = {
        source = ./utils/install.sh;
        mode = "0700";
      };
      "utils/partition.sh" = {
        source = ./utils/partition.sh;
        mode = "0700";
      };
      "utils/mem.sh" = {
        source = ./utils/mem.sh;
        mode = "0700";
      };
      "utils/configuration.nix" = { source = ./utils/configuration.nix; };
    };
  };

  environment.variables = { PATH = [ "/bin" "/usr/bin" "etc/utils" ]; };
}
