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
    Type = lib.mkForce "simple";
    # FIX: Changed "no" string to boolean false to match Nixpkgs types
    IgnoreSIGPIPE = lib.mkForce false;
    
    # Standard TTY streams
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;

    # Enterprise Hardening & Security Sandboxing
    CapabilityBoundingSet = [ "CAP_SYS_TTY_CONFIG" "CAP_AUDIT_WRITE" ];
    DeviceAllow = [ "/dev/tty1 rwm" "/dev/dri/card* rwm" "/dev/dri/renderD* rw" "/dev/input/* r" ];
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    RestrictRealtime = true;
  };
}
