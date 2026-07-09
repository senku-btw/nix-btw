# ~/nix-btw/services/greetd.nix
{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # OPTIMIZATION: Added the --remember and --remember-session flags 
        # alongside an explicit fallback command if no session history exists yet.
        command = "${lib.getExe pkgs.tuigreet} --time --asterisks --remember --remember-session --sessions /run/current-system/sw/share/wayland-sessions --cmd mangowm-session";
        user = "greeter";
      };
    };
  };

  # Production-Grade Lifecycle Configuration
  systemd.services.greetd.serviceConfig = {
    # Keep the default "idle" type to guarantee the graphics pipeline is fully up before running
    Type = lib.mkForce "idle";
    
    # Standard TTY streams required for a clean text/graphical interface handoff
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
