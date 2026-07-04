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
  environment.sessionVariables = lib.mkForce {};

  systemd.user.settings.Manager = {
    DefaultEnvironment = "\"WLR_NO_HARDWARE_CURSORS=1\" \"_JAVA_AWT_WM_NONREPARENTING=1\" \"SDL_VIDEODRIVER=wayland,x11\" \"QT_QPA_PLATFORM=wayland;xcb\"";
  };

  # EXCLUDE LEGACY SESSIONS: Tell the system display manager to look ONLY at UWSM sessions
  # This blocks the legacy `niri.desktop` from being generated/seen by tuigreet
  services.displayManager.sessionPackages = lib.mkForce [
    (pkgs.writeTextDir "share/wayland-sessions/niri-uwsm.desktop" ''
      [Desktop Entry]
      Name=Niri (UWSM)
      Comment=Niri scrollable-tiling compositor managed by UWSM
      Exec=${lib.getExe pkgs.uwsm} start niri-uwsm.desktop
      Type=Application
    '')
  ];
}
