# ~/nix-btw/users/gandalf/profile.nix
{ config, pkgs, ... }:

{
  # Structural Hook: Link the user's specific Home Manager profile to this system module
  home-manager.users.gandalf = import ./home-manager.nix;

  # Core system user declaration
  users.users.gandalf = {
    isNormalUser = true;
    
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
