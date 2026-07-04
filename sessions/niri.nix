# ~/nix-btw/sessions/niri.nix
{ config, pkgs, lib, ... }:

{
  # 1. Enable Niri infrastructure natively via NixOS options
  programs.niri.enable = true;

  # 2. Modern Session Management via UWSM
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      niri = {
        prettyName = "Niri";
        comment = "Niri scrollable-tiling compositor managed by UWSM";
        binPath = "${lib.getExe pkgs.niri}";
        extraArgs = [ "--session" ];
      };
    };
  };

  # 3. Handle Graphical Session Environment Safely
  environment.sessionVariables = lib.mkForce {}; # Clean up global environment hooks

  # Correct type-safe way to inject user session environment variables into systemd
  systemd.user.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    SDL_VIDEODRIVER = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
