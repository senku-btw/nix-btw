# ~/nix-btw/sessions/niri.nix
{ config, pkgs, lib, ... }:

{
  # 1. Enable Niri infrastructure natively via NixOS options
  programs.niri.enable = true;

  # 2. Modern Session Management via UWSM (Universal Wayland Session Manager)
  # This avoids environment pollution, prevents systemd path shadowing,
  # and drastically speeds up compositor loading by isolating the graphical session.
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
  # UWSM handles passing these into the systemd user activation environment,
  # eliminating deprecation warnings and keeping standard shells clean.
  environment.sessionVariables = lib.mkForce {}; # Flushes out legacy variable formats if inherited

  # We bind variables natively via the systemd user environment structure for the compositor target
  systemd.user.extraConfig = ''
    DefaultEnvironment="WLR_NO_HARDWARE_CURSORS=1" "_JAVA_AWT_WM_NONREPARENTING=1" "SDL_VIDEODRIVER=wayland,x11" "QT_QPA_PLATFORM=wayland;xcb"
  '';
}
