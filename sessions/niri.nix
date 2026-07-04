# ~/nix-btw/sessions/niri.nix
{ config, pkgs, ... }:

{
  # Enable Niri Infrastructure safely
  programs.niri.enable = true;

  # This option tells Niri not to let standard systemd paths shadow its startup sequence,
  # preventing the environment pollution warnings.
  systemd.user.services.niri.enableDefaultPath = false;

  # Clean wrapper targeting only graphical elements without polluting the shell configuration files
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    SDL_VIDEODRIVER = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
