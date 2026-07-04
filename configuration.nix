# ~/nix-btw/configuration.nix
{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware/baseline.nix
    ./hardware/nvidia-graphics.nix
    ./services/pipewire.nix
    ./services/desktop-environment.nix
  ];

  networking.hostName = "nix-btw";

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable Flakes and the new 'nix' CLI
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow proprietary/unfree packages (Required for Nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  i18n.defaultLocale = "en_US.UTF-8";

  # Changed user from 'groot' to 'batman'
  users.users.batman = {
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
