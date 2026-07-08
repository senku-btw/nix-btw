# ~/nix-btw/users/admin/profile.nix
{ config, pkgs, lib, ... }:

let
  cfg = config.profiles.admin;
in
{
  # Module option declarations
  options.profiles.admin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false; # Note: Make sure you set profiles.admin.enable = true; in configuration.nix!
    };
  };

  # Target configuration implementation
  config = lib.mkIf cfg.enable {
    # Home Manager integration hooks (This is the ONLY place this should be imported)
    home-manager.users.admin = {
      imports = [ ./home-manager.nix ];
    };

    # System user account definitions
    users.users.admin = {
      isNormalUser = true;
      hashedPasswordFile = "/var/lib/secrets/admin-password";
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
