# ~/nix-btw/services/desktop-environment.nix
{ config, pkgs, lib, ... }: # <-- Make sure 'lib' is included here at the very top!

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
  # We use lib.mkForce to elegantly merge our TUI console routing over the defaults
  systemd.services.greetd.serviceConfig = lib.mkForce {
    Type = "idle"; # Follows upstream recommended behavior for console managers
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

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
