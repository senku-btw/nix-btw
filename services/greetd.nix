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

  systemd.services.greetd.serviceConfig = {
    Type = lib.mkForce "simple";
    IgnoreSIGPIPE = lib.mkForce false;
    
    # Standard TTY streams
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;

    # Enterprise Hardening (Optimized for Hardware Initialization)
    # We broaden DeviceAllow to allow all character devices to prevent DRM/graphics seat race conditions
    CapabilityBoundingSet = [ "CAP_SYS_TTY_CONFIG" "CAP_AUDIT_WRITE" ];
    DeviceAllow = [ "char-* rw" ]; 
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    RestrictRealtime = true;
  };
}
