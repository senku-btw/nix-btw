# ~/nix-btw/boot/networking.nix
{ config, lib, pkgs, ... }:

{
  # Define system network identity
  networking.hostName = "nix-btw";

  # Enable NetworkManager for simple Wi-Fi and ethernet management
  networking.networkmanager.enable = true;

  # Strict firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # Allow SSH incoming connections
  };
}
