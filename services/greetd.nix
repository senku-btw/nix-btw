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

  # Production-Grade Lifecycle Configuration (Relying on safe NixOS Defaults)
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
