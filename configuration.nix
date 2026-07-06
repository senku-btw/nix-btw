# ~/nix-btw/configuration.nix
{ config, lib, pkgs, ... }:

{
  imports = [ 
    # Core system boot and hardware mapping
    ./boot/hardware-configuration.nix
    ./boot/baseline.nix
    ./boot/networking.nix

    # Hardware drivers
    ./drivers/nvidia-graphics.nix

    # Core system services & audio pipeline
    ./services/pipewire.nix
    ./services/wireplumber.nix
    ./services/greetd.nix
    ./services/ssh.nix

    # Desktop sessions & user packages
    ./sessions/niri.nix
    ./packages/system-packages.nix

    # User identity profiles & Home Manager hooks
    ./users/senku/profile.nix
  ];

  nix = {
    settings = {
      # Enable modern Nix capabilities
      experimental-features = [ "nix-command" "flakes" ];
      
      # Deduplicate the store automatically to save disk space
      auto-optimise-store = true;
      
      # Prevent accidental deletion of build dependencies during GC
      keep-outputs = true;
      keep-derivations = true;
    };

    # Automate storage maintenance & generation pruning
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Permit proprietary binaries (Mandatory for proprietary Nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  # Set system-wide language environment
  i18n.defaultLocale = "en_US.UTF-8";

  # Define system state version for backwards compatibility overrides
  system.stateVersion = "26.05";
}
