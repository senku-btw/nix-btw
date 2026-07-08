# ~/nix-btw/drivers/nvidia-graphics.nix
{ config, pkgs, lib, ... }:

{
  # Permit proprietary binaries (Mandatory for proprietary Nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  boot = {
    # Appends Nvidia-specific flags cleanly to the global kernel array
    kernelParams = [
      "nvidia-drm.modeset=1" 
      "nvidia-drm.fbdev=1"
    ];
    
    blacklistedKernelModules = [ "nouveau" ];
    tmp.cleanOnBoot = true;
  };

  # Global environment variables to force flawless Wayland compliance on Pascal GPUs
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WIR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = { 
      enable = true; 
      enable32Bit = true; 
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      open = false; 
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  systemd.services.nvidia-suspend.wantedBy = [ "systemd-suspend.service" ];
  systemd.services.nvidia-resume.wantedBy = [ "systemd-suspend.service" ];
  systemd.services.nvidia-hibernate.wantedBy = [ "systemd-hibernate.service" ];
}
