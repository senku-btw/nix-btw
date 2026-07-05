# ~/nix-btw/sessions/niri.nix
{ config, pkgs, lib, ... }:

{
  programs.niri.enable = true;

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      niri = {
        prettyName = "Niri";
        comment = "Niri scrollable-tiling compositor managed by UWSM";
        binPath = "${lib.getExe pkgs.niri}";
        # ENTERPRISE FIX: Bypass the wrapper script by passing the native session flag directly to the binary
        extraArgs = [ "--session" ]; 
      };
    };
  };

  # Modern, declarative user variables automatically handled by UWSM
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    SDL_VIDEODRIVER = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
