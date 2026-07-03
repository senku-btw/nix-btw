# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  # Enable Flakes and the new 'nix' CLI
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.groot = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      fastfetch
    ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    nano
    wget
    git
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # -------------------------------------------------------------------
  # SSH & Firewall Configuration
  # -------------------------------------------------------------------
  services.openssh = {
    enable = true;
    settings = {
      # For security, do not allow root to log in via SSH
      PermitRootLogin = "no";
      # Allow password authentication for user 'groot'
      PasswordAuthentication = true;
    };
  };

  # Open ports in the firewall for SSH
  networking.firewall.allowedTCPPorts = [ 22 ];

  # -------------------------------------------------------------------

  # This option defines the first version of NixOS you have installed on this particular machine.
  system.stateVersion = "26.05"; # Did you read the comment?
}
