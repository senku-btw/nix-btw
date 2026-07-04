# ~/nix-btw/configuration.nix
{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware/baseline.nix
    ./hardware/nvidia-graphics.nix
    ./hardware/networking.nix
    ./services/pipewire.nix
    ./services/desktop-environment.nix
    ./services/ssh.nix
    ./packages/system-packages.nix
    ./users/senku-btw/profile.nix
  ];

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

  system.stateVersion = "26.05";
}
