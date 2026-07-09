# ~/nix-btw/boot/systemd.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader Architecture
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
 
  # LUKS Encrypted Container Initialization
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;     # Compulsory for long-term NVMe life and speed
    bypassWorkqueues = true;  # Bypasses CPU workqueue lag for direct NVMe crypto execution
  };

  # Recommended for maximum stability on production workstations
  boot.kernelPackages = pkgs.linuxPackages_LTS;

  # Instantly boots the default generation without showing the menu
  boot.loader.timeout = 0;

  # Initrd & systemd streamlining (Extreme minimalism)
  boot.initrd.systemd.enable = true;
  boot.initrd.compressor = "zstd"; 
  boot.initrd.compressorArgs = [ "-1" ]; # Correct NixOS syntax for passing compression levels
  
  # Strip unneeded kernel modules to radically shrink initrd size
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "btrfs"
  ];

  # Prevent asynchronous service checks from blocking your desktop login target
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-udev-settle.enable = false;

  # Mask heavy, blocking, or irrelevant early hardware debugging/tracking tasks
  systemd.maskedServices = [
    "sys-kernel-debug.mount"
    "sys-kernel-config.mount"                # Disables configfs (unnecessary for standard workstations)
    "pstore.mount"                           # Disables persistent storage mounts for kernel dumps
    "systemd-pstore.service"                 # Stops systemd from processing historic crash logs on boot
    "systemd-boot-check-no-failures.service" # Bypasses sync barrier waiting for 100% clean unit states
  ];

  # Global Systemd Timeout Optimizations (Eliminates the 90-second shutdown hang)
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=10s
    DefaultTimeoutStopSec=10s
  '';

  # Prevent Journald from performing massive historic index disk-reads during early boot
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    SystemMaxFileSize=20M
    Storage=persistent
  '';

  # Enterprise error monitoring with dead-silent boot presentation
  boot.consoleLogLevel = 3; # Level 3 (Errors) prevents a broken machine from hiding its failure
  boot.initrd.verbose = false; 

  boot.kernelParams = [
    # --- Silent Boot Presentation ---
    "quiet"                                 
    "loglevel=3"                            # Suppress fluff, but expose hardware crises
    "printk.devkmsg=off"                    
    "systemd.show_status=auto"              
    "rd.systemd.show_status=auto"          
    "systemd.log_level=err"                 
    "udev.log_level=3"                      # Log errors only; 0 makes USB/Dock debugging impossible
    "rd.udev.log_level=3"                    
    "acpi.log_errors=0"                     
    "vt.global_cursor_default=0"            
    "fbcon=nodefer"                         

    # --- Hardware & Boot Performance ---
    "fastboot"                              
    "libahci.ignore_sss=1"                  
    "lp=0"                                  
    "io_delay=none"                         
    "nvme_core.default_ps_max_latency_us=0" # Max-performance NVMe state (No power-state stutters)
  ];

  # High-performance runtime storage (Aggressive Btrfs tuning)
  fileSystems."/" = {
    fsType = "btrfs";
    options = [ 
      "subvol=@" 
      "noatime"           # Disables file access time updates completely
      "discard=async"     # Continuous background SSD TRIM (maintains NVMe write speeds)
      "space_cache=v2"    
      "compress=zstd:1"   # Ultra-fast, low-overhead transparent compression
    ];
  };
}
