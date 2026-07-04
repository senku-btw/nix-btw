# ~/nix-btw/services/greetd.nix
{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Using lib.getExe for robust binary paths.
        # We explicitly point tuigreet to the system-wide wayland-sessions directory 
        # where UWSM exposes its optimized compositor wrappers.
        command = ''
          ${lib.getExe pkgs.tuigreet} \
            --time \
            --remember \
            --remember-session \
            --sessions /run/current-system/sw/share/wayland-sessions
        '';
        user = "greeter";
      };
    };
  };

  # Production-hardened Systemd TTY Override Guard
  # Prevents boot log bleeding, handles vt switching safely, and isolates execution.
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
