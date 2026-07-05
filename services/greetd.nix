# ~/nix-btw/services/greetd.nix
{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # FIX: Changed pkgs.greetd.tuigreet to pkgs.tuigreet
        command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-session --sessions /run/current-system/sw/share/wayland-sessions";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
