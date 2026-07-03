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
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri";
        user = "greeter";
      };
    };
  };

  # 3. Systemd TTY Override Guard
  systemd.services.greetd.serviceConfig = {
    Type = "simple";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # 4. Golden-Standard Wayland & NVIDIA Optimization Variables
  environment.sessionVariables = {
    # --- Desktop Identity Protocols ---
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";

    # --- Hardware & Core Renderer Tuning ---
    WLR_NO_HARDWARE_CURSORS = "1";     # Prevents invisible/flickering cursors on NVIDIA drivers
    GBM_BACKEND = "nvidia-drm";        # Forces the Generic Buffer Management API onto NVIDIA's driver kernel path
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # Dictates GLX applications to cleanly link against the NVIDIA vendor library
    LIBVA_DRIVER_NAME = "nvidia";      # Enables hardware video playback decoding acceleration via NVDEC

    # --- UI Toolkit Native Compilations ---
    NIXOS_OZONE_HLWM = "1";            # Electron/Chromium stack accelerator (VSCode, Discord, Chrome, Brave)
    MOZ_ENABLE_WAYLAND = "1";          # Forces Firefox to discard XWayland degradation and run purely native
    
    GTK_BACKEND = "wayland";           # Instructs GTK 3/4 applications to talk directly to Niri
    QT_QPA_PLATFORM = "wayland;xcb";   # Instructs Qt 5/6 applications to prefer Wayland native, falling back safely to XWayland if legacy
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Drops redundant server-side window boarders since Niri handles them beautifully

    # --- High-Performance Gaming Abstractions ---
    SDL_VIDEODRIVER = "wayland";       # Directs modern game engines utilizing SDL2 natively to Wayland
    _JAVA_AWT_WM_NONREPARENTING = "1"; # Solves a major bug where Java applications (like Minecraft launchers) appear completely blank
  };

  # 5. Core Minimal Desktop Tooling Block
  environment.systemPackages = with pkgs; [
    alacritty       # High-performance, GPU-accelerated Wayland-native terminal emulator
    xdg-utils       # Crucial for cross-application linking, URL forwarding, and file protocols
    fuzzel          # Pure Wayland application launcher (dmenu/rofi alternative)
  ];
}
