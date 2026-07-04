# ~/nix-btw/hardware/nvidia-graphics.nix
{ config, pkgs, ... }:

{
  boot = {
    # Include out-of-tree kernel modules for the driver
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

    extraModprobeConfig = "options vfio-pci ids=1022:1487";
    
    # Early KMS initrd module loading for Nvidia and VFIO
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "vfio-pci" ];
    
    # Merged silent boot parameters with Wayland Nvidia flags
    kernelParams = [
      "nvidia-drm.modeset=1" 
      "nvidia-drm.fbdev=1"
      "quiet" 
      "splash" 
      "boot.shell_on_fail"
      "rd.systemd.show_status=false" 
      "rd.udev.log_level=0" 
      "acpi_osi=Linux"
    ];
    
    consoleLogLevel = 0;
    blacklistedKernelModules = [ "nouveau" ];
    tmp.cleanOnBoot = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = { 
      enable = true; 
      enable32Bit = true; 
    };
    nvidia = {
      # Pinning to the exact legacy branch that your 1050 Ti requires
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      open = false; # Legacy 580 requires the proprietary modules
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
