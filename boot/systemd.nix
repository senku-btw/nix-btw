{ config, lib, pkgs, ... }:

{
  # --- Bootloader Architecture ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3; 

  # --- LUKS Encrypted Container Initialization ---
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/disk/by-uuid/a4232927-3a94-4f36-aad6-caca4af1bada";
    allowDiscards = true;      
    bypassWorkqueues = true;   
  };

  # Use latest stable kernel for modern CPU scheduler enhancements
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # --- Initrd & Systemd Streamlining ---
  boot.initrd.systemd.enable = true;
  boot.initrd.compressor = "zstd";
  boot.initrd.compressorArgs = [ "-1" ];
  boot.initrd.includeDefaultModules = true;

  boot.initrd.availableKernelModules = [
    "nvme"          
    "xhci_pci"      
    "usbhid"        
    "usb_storage"   
    "btrfs"         
  ];

  # --- Systemd Service Optimizations ---
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-udev-settle.enable = false;
  
  systemd.settings.Manager = {
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
  };

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    SystemMaxFileSize=20M
    Storage=persistent
  '';

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  # --- Advanced Kernel Parameters ---
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "printk.devkmsg=off"
    "systemd.show_status=auto"
    "rd.systemd.show_status=auto"
    "systemd.log_level=err"
    "udev.log_level=3"
    "rd.udev.log_level=3"
    "acpi.log_errors=0"
    "fastboot"
    "lp=0"
    "noresume"
    "nvidia-drm.modeset=1"
  ];

  # --- High-Performance Runtime Storage (Btrfs tuning) ---
  fileSystems."/" = {
    fsType = "btrfs";
    options = [ 
      "subvol=@root"     
      "noatime"         
      "discard=async"   
      "compress=zstd:1" 
    ];
  };  
}
