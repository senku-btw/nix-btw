# ~/nix-btw/services/system-maintenance.nix
{ config, lib, pkgs, ... }:

{
  nix = {
    settings = {
      # Defer hardlinking away from active build cycles to protect disk bandwidth
      auto-optimise-store = false;

      # Protect working shells, active gc-roots, and build dependencies
      keep-outputs = true;
      keep-derivations = true;

      # Dynamically match processor topology without saturating core limits
      max-jobs = "auto";
    };

    # Predictable Weekly GC Routine
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
      persistent = true; 
    };

    # Decoupled Store Deduplication
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # Workstation-Optimized Resource Constraints
  systemd.services = {
    nix-gc = {
      serviceConfig = {
        # CPU: Low priority, but guaranteed execution (does not stall out like 'idle')
        Nice = 19;
        
        # IO: Keeps massive file unlinking from causing UI micro-stutters
        IOSchedulingClass = "idle";
        IOSchedulingPriority = 7;
      };
    };

    nix-optimise = {
      serviceConfig = {
        # CPU: Deduplication relies heavily on crypto hashing; keep it strictly background tier
        Nice = 19;
        
        # IO: Prevents massive hardlink generation from stalling interactive apps
        IOSchedulingClass = "idle";
        IOSchedulingPriority = 7;
      };
    };
  };
}
