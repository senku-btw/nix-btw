# ~/nix-btw/sessions/niri.nix
{ config, pkgs, ... }:

{
  # Enable Niri Wayland Compositor Infrastructure
  programs.niri.enable = true;

  # Global desktop session variables for app rendering stability
  environment.sessionVariables = {
    # Desktop Environment identification hooks
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";

    # Toolkit environment force-routing flags for native Wayland execution
    MOZ_ENABLE_WAYLAND = "1";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    # Prevents blank grey windows in legacy Java GUI frameworks
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
