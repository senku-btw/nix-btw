# ~/nix-btw/services/greetd.nix
{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Configured tuigreet to look dynamically inside the system's wayland-sessions folder
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --wsessions /run/current-system/sw/share/wayland-sessions";
        user = "greeter";
      };
    };
  };

  # Systemd TTY Override Guard to prevent boot log bleeding
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
