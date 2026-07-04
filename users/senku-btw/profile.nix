# ~/nix-btw/users/senku-btw/profile.nix
{ config, pkgs, ... }:

{
  # Structural Hook: Link the user's specific Home Manager profile to this system module
  home-manager.users.senku-btw = import ./home-manager.nix;

  # Core system user declaration
  users.users.senku-btw = {
    isNormalUser = true;
    description = "Primary Workstation Operator";
    
    # Unified group assignments for modern desktop and hardware acceleration pipelines
    extraGroups = [ 
      "wheel"           # Administrative privilege escalation (sudo)
      "networkmanager"  # Network control capabilities
      "video"           # Local video device access
      "input"           # Input event processing permissions
    ];
    
    # Cryptographic SSH access control lists
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..." # Add your public deployment key here
    ];
  };
}
