# ~/nix-btw/sessions/mangowm.nix
# Enterprise-Grade MangoWM Composition & Session Registration Module

{ config, pkgs, lib, ... }:

let
  # Structural wrapper defining the environment and starting MangoWM
  # Uses safe wrappers to guarantee standard variables persist across session handoff
  mangoSessionStartup = pkgs.writeShellScriptBin "mangowm-session" ''
    # --- Environment Hardening & Sanitization ---
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=MangoWM
    export XDG_SESSION_DESKTOP=MangoWM

    # Native Wayland routing for main enterprise UI toolkits
    export NIXOS_OZONE_WL="1"
    export MOZ_ENABLE_WAYLAND="1"
    export QT_QPA_PLATFORM="wayland;xcb"
    export SDL_VIDEODRIVER="wayland"
    export CLUTTER_BACKEND="wayland"
    
    # Fix Java rendering glitches on non-reparenting Wayland window managers
    export _JAVA_AWT_WM_NONREPARENTING=1

    # --- Session Execution ---
    # Execute MangoWM cleanly, replacing the shell process
    exec ${lib.getExe pkgs.mangowm}
  '';

  # Declarative generation of the .desktop entry required by tuigreet
  mangowmDesktopSession = pkgs.writeTextDir "share/wayland-sessions/mangowm.desktop" ''
    [Desktop Entry]
    Name=MangoWM
    Comment=Production-Grade High Performance Tile/Grid Window Manager
    Exec=${lib.getExe mangoSessionStartup}
    Type=Application
    DesktopNames=MangoWM
  '';
in
{
  options = {
    # Provides toggle hooks if importing into multi-profile infrastructure
    services.mangowm-session.enable = lib.mkEnableOption "Production MangoWM session architecture";
  };

  config = lib.mkIf config.services.mangowm-session.enable {
    # 1. Provide core package suite dependencies
    environment.systemPackages = [
      pkgs.mangowm
      mangoSessionStartup
      mangowmDesktopSession  # Exposes the desktop file to /run/current-system/sw/share/wayland-sessions
    ];

    # 2. XDG Desktop Portal Pipeline - Critical for Screen Sharing, Audio, & Inhibitors
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "wlr" "gtk" ];
    };

    # 3. Hardware / Pipeline acceleration infrastructure
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # 4. Declarative Asset Configuration
    # Drops your production configuration for MangoWM natively into the target workspace paths
    environment.etc."mango/mangowm.conf".text = ''
      # MangoWM Enterprise Configuration Profile
      
      # Core Composition Layout Styles
      blur = 1
      shadows = 1
      border_radius = 4
      focused_opacity = 1.0

      # Motion Profiles
      animations = 1
      animation_type_open = slide
      animation_duration_open = 250

      # Explicit Structural Workspaces Tags
      tagrule = [
        { id = 1, layout_name = "tile" }
        { id = 2, layout_name = "scroller" }
        { id = 3, layout_name = "grid" }
      ]
    '';
  };
}
