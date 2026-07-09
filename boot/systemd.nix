{ config, lib, pkgs, ... }:

{
  # --- Bootloader Architecture ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Safe buffer allowing you to interrupt boot if something breaks
  boot.loader.timeout = 3; 

  # --- LUKS Encrypted Container Initialization ---
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  # Kernel Choice (Defaults to the official NixOS LTS kernel release)
  boot.kernelPackages = pkgs.linuxPackages;
  
  # --- Initrd & Systemd Streamlining ---
  boot.initrd.systemd.enable = true;
  boot.initrd.compressor = "zstd";
  boot.initrd.compressorArgs = [ "-1" ];
  boot.initrd.includeDefaultModules = false;
 
  # Expanded to safeguard keyboard hardware detection
  boot.initrd.availableKernelModules = [
    "nvme"          # NVMe storage drive paths
    "xhci_pci"      # USB 3.x host controllers
    "usbhid"        # Standard USB keyboards
    "usb_storage"   # USB mass storage
    "btrfs"         # Root filesystem driver
    "i2c_hid"       # Common laptop internal keyboards (I2C)
    "i2c_hid_acpi"  # ACPI mapping for modern internal keyboards
    "intel_lpss_pci"# Lower-level bus wrapper for Intel-based laptops
  ];

  # --- Systemd Service Optimizations ---
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-udev-settle.enable = false;
  
  # --- Masked Systemd Units ---
  systemd.units = {
    "sys-kernel-debug.mount".enable = lib.mkForce false;
    "sys-kernel-config.mount".enable = lib.mkForce false;
    "pstore.mount".enable = lib.mkForce false;
    "systemd-pstore.service".enable = lib.mkForce false;
  };
  
  # --- Global Systemd Timeouts ---
  systemd.settings.Manager = {
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
  };

  # --- Journald Log Constraints ---
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    SystemMaxFileSize=20M
    Storage=persistent
  '';

  # --- Console Logging Constraints ---
  # Set to 3 (Errors Only) instead of 0 so you can actually see the password input text
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  # --- Advanced Kernel Parameters ---
  boot.kernelParams = [
    "quiet"
    "loglevel=3" # Errors only, keeping boot text clean but exposing visual failures
    "printk.devkmsg=off"
    "systemd.show_status=auto"
    "rd.systemd.show_status=auto"
    "systemd.log_level=err"
    "udev.log_level=3"
    "rd.udev.log_level=3"
    "acpi.log_errors=0"
    "vt.global_cursor_default=0"
    "fbcon=nodefer"    
    "fastboot"
    "libahci.ignore_sss=1"
    "lp=0"
    "io_delay=none"
    "nvme_core.default_ps_max_latency_us=0"
  ];

  # --- High-Performance Runtime Storage (Btrfs tuning) ---
  fileSystems."/" = {
    fsType = "btrfs";
    options = [ 
      "subvol=@" 
      "noatime"         
      "nodiratime"      
      "discard=async"   
      "space_cache=v2"  
      "compress=zstd:1" 
    ];
  };  
}
