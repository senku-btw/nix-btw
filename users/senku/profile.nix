# ~/nix-btw/users/senku/profile.nix
{ config, pkgs, lib, ... }:

let
  cfg = config.profiles.senku;
in
{
  # Module composition -> Empty this or remove it entirely!
  imports = [ 
    # REMOVED ./home-manager.nix from here
  ];

  # Module option declarations
  options.profiles.senku = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false; # Note: Make sure you set profiles.senku.enable = true; in configuration.nix!
    };
  };

  # Target configuration implementation
  config = lib.mkIf cfg.enable {
    # Home Manager integration hooks (This is the ONLY place this should be imported)
    home-manager.users.senku = {
      imports = [ ./home-manager.nix ];
    };

    # System user account definitions
    users.users.senku = {
      isNormalUser = true;
      description = "Senku Ishigami";
      extraGroups = [ 
        "wheel" 
        "networkmanager" 
        "video" 
        "input" 
      ];
      
      # Security and access controls
      openssh.authorizedKeys.keys = [
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."
      ];
    };
  };
}
