# ~/nix-btw/drivers/nvidia-graphics.nix
{ config, pkgs, lib, ... }:

{
  boot = {
    # Core kernel parameters for Nvidia Wayland stability and explicit sync
    kernelParams = [
      "nvidia-drm.modeset=1" 
      "nvidia-drm.fbdev=1"
    ];
    
    blacklistedKernelModules = [ "nouveau" ];
    tmp.cleanOnBoot = true;
  };

  # Global environment variables to force flawless Wayland compliance on Pascal GPUs
  environment.sessionVariables = {
    # Force Electron/Chromium apps to use Wayland natively
    NIXOS_OZONE_WL = "1";
    
    # Direct hardware acceleration pipelines to use Nvidia instead of fallback Mesa drivers
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    
    # Fixes invisible cursor rendering bugs common in wlroots/Niri on older Nvidia cards
    WLR_NO_HARDWARE_CURSORS = "1";

    # Hardware acceleration flags for video playback
    LIBVA_DRIVER_NAME = "nvidia";
  };

  hardware = {
    enableRedistributableFirmware = true;
    
    graphics = { 
      enable = true; 
      enable32Bit = true; 
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };

    nvidia = {
      # Explicitly track the legacy 580 branch required for the GTX 1050 Ti
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      
      # Legacy 580 requires the proprietary driver modules
      open = false; 
      
      modesetting.enable = true;
      nvidiaSettings = true;
      
      # Preserves video memory allocations through sleep/suspend to prevent graphical corruption
      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
  };

  # Hook the display pipeline up to the Nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enterprise Stability: Ensure systemd power management services run reliably
  systemd.services.nvidia-suspend.wantedBy = [ "systemd-suspend.service" ];
  systemd.services.nvidia-resume.wantedBy = [ "systemd-suspend.service" ];
  systemd.services.nvidia-hibernate.wantedBy = [ "systemd-hibernate.service" ];
}
