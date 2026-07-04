# ~/nix-btw/services/greetd.nix
{ config, pkgs, ... }:

{
  # Configure greetd with the Ultra-Lightweight TUI Greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri";
        user = "greeter";
      };
    };
  };

  # Systemd TTY Override Guard
  systemd.services.greetd.serviceConfig.Type = "idle";
  systemd.services.greetd.serviceConfig.StandardInput = "tty";
  systemd.services.greetd.serviceConfig.StandardOutput = "tty";
  systemd.services.greetd.serviceConfig.StandardError = "journal";
  systemd.services.greetd.serviceConfig.TTYReset = true;
  systemd.services.greetd.serviceConfig.TTYVHangup = true;
  systemd.services.greetd.serviceConfig.TTYVTDisallocate = true;
}
