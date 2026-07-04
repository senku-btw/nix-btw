# ~/nix-btw/services/niri.nix
{ config, pkgs, ... }:

{
  # Enable Niri Wayland Compositor Infrastructure
  programs.niri.enable = true;

  # Golden-Standard Wayland & NVIDIA Optimization Variables
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";     
    GBM_BACKEND = "nvidia-drm";        
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; 
    LIBVA_DRIVER_NAME = "nvidia";      
    NIXOS_OZONE_HLWM = "1";            
    MOZ_ENABLE_WAYLAND = "1";          
    GTK_BACKEND = "wayland";           
    QT_QPA_PLATFORM = "wayland;xcb";   
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; 
    SDL_VIDEODRIVER = "wayland";       
    _JAVA_AWT_WM_NONREPARENTING = "1"; 
  };
}
