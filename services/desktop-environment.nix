# ~/nix-btw/services/desktop-environment.nix
{ config, pkgs, ... }:

{
  # 1. Enable Niri Wayland Compositor Infrastructure
  programs.niri.enable = true;

  # 2. Configure greetd with the Ultra-Lightweight TUI Greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri";
        user = "greeter";
      };
    };
  };

  # 3. Systemd TTY Override Guard
  # Injected directly to merge cleanly with the upstream service definitions
  systemd.services.greetd.serviceConfig.Type = "idle";
  systemd.services.greetd.serviceConfig.StandardInput = "tty";
  systemd.services.greetd.serviceConfig.StandardOutput = "tty";
  systemd.services.greetd.serviceConfig.StandardError = "journal";
  systemd.services.greetd.serviceConfig.TTYReset = true;
  systemd.services.greetd.serviceConfig.TTYVHangup = true;
  systemd.services.greetd.serviceConfig.TTYVTDisallocate = true;

  # 4. Golden-Standard Wayland & NVIDIA Optimization Variables
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

  # 5. Core Minimal Desktop Tooling Block
  environment.systemPackages = with pkgs; [
    alacritty       
    xdg-utils       
    fuzzel          
  ];
}
