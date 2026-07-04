# ~/nix-btw/hardware/networking.nix
{ config, lib, pkgs, ... }:

{
  networking.hostName = "nix";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  networking.firewall.allowedTCPPorts = [ 22 ];
}
