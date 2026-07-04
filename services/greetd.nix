# ~/nix-btw/services/greetd.nix
{ config, pkgs, lib, ... }:

let
  # Create a clean, isolated directory containing ONLY the optimized UWSM session
  customSessions = pkgs.linkFarm "tuigreet-sessions" [
    {
      name = "share/wayland-sessions/niri-uwsm.desktop";
      path = pkgs.writeText "niri-uwsm.desktop" ''
        [Desktop Entry]
        Name=Niri (UWSM)
        Comment=Niri scrollable-tiling compositor managed by UWSM
        Exec=${lib.getExe pkgs.uwsm} start niri-uwsm.desktop
        Type=Application
      '';
    }
  ];
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Point tuigreet EXCLUSIVELY to our isolated custom directory
        command = ''
          ${lib.getExe pkgs.tuigreet} \
            --time \
            --remember \
            --remember-session \
            --sessions ${customSessions}/share/wayland-sessions
        '';
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
