# ~/nix-btw/users/senku/profile.nix
{ config, pkgs, lib, ... }:

let
  cfg = config.profiles.senku;
in
{
  # Module composition
  imports = [ 
    ./home-manager.nix 
  ];

  # Module option declarations
  options.profiles.senku = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  # Target configuration implementation
  config = lib.mkIf cfg.enable {
    # Home Manager integration hooks
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
