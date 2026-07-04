# ~/nix-btw/boot/baseline.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader core configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Standard kernel parameter optimizations for modern desktop systems
  boot.kernelParams = [ "quiet" "splash" ];
}
