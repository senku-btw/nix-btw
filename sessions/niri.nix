# ~/nix-btw/sessions/niri.nix
{ config, pkgs, ... }:

{
  # Enable Niri Infrastructure
  programs.niri.enable = true;

  # Feed the hardware cursor fix and toolkit tweaks directly into Niri's systemd user services
  systemd.user.services.niri = {
    environment = {
      WLR_NO_HARDWARE_CURSORS = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      SDL_VIDEODRIVER = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
