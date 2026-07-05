# ~/nix-btw/services/greetd.nix
{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --asterisks --remember --remember-session --sessions /run/current-system/sw/share/wayland-sessions";
        user = "greeter";
      };
    };
  };

  # Peak Performance & Hardened Security Systemd Configuration
  systemd.services.greetd.serviceConfig = {
    # Speed Optimization: Instant execution alongside system initialization
    Type = "simple";
    IgnoreSIGPIPE = "no";
    
    # Standard TTY streams
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;

    # Enterprise Hardening & Security Sandboxing
    # Ensures the greeter process runs with the absolute bare minimum privileges required for a display manager
    CapabilityBoundingSet = [ "CAP_SYS_TTY_CONFIG" "CAP_AUDIT_WRITE" ];
    DeviceAllow = [ "/dev/tty1 rwm" "/dev/dri/card* rwm" "/dev/dri/renderD* rw" "/dev/input/* r" ];
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    RestrictRealtime = true;
  };
}
