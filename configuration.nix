# ~/nix-btw/configuration.nix
{ config, lib, pkgs, ... }:

{
  imports = [ 
    # Explicitly targeting your baseline file
    ./hardware/baseline.nix
  ];

  networking.hostName = "nix-btw";

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.groot = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [];
  };

  environment.systemPackages = with pkgs; [
    nano
    wget
    git
    tree
    fastfetch
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; 
      KbdInteractiveAuthentication = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "26.05";
}
