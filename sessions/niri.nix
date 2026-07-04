# ~/nix-btw/sessions/niri.nix
{ config, pkgs, ... }:

{
  # Enable Niri Infrastructure
  programs.niri.enable = true;

  # Route toolkit overrides the safe way
  environment.sessionVariables = {
    # Keep legacy Java and multi-backend fallbacks safe
    _JAVA_AWT_WM_NONREPARENTING = "1";
    SDL_VIDEODRIVER = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  # Direct hardware cursor override to fix the glitching mouse rectangle
  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
