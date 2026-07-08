{ config, lib, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Speed optimization: Set bootloader timeout to 0 seconds.
  # (Hold Spacebar or Shift during boot if you ever need to access the menu)
  boot.loader.timeout = 0;

  # Use the XanMod kernel (excellent choice for desktop responsiveness)
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Use systemd in the initrd for robust, parallelized service execution
  boot.initrd.systemd.enable = true;

  # Silence boot output completely
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false; 

  boot.kernelParams = [
    # General (Mutes standard text output channels)
    "quiet"

    # Kernel logging
    "loglevel=0"
    "printk.devkmsg=off"

    # Hide systemd status messages
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "systemd.log_level=err" 

    # Reduce udev logging
    "udev.log_level=0" 
    "rd.udev.log_level=0"

    # Suppress ACPI interpreter errors completely
    "acpi.log_errors=0"
    "vt.global_cursor_default=0"
    
    # Speed optimization: Fast storage probing and asynchronous hardware indexing
    "fastboot"                   # Skips non-essential hardware checks on early boot
    "libahci.ignore_sss=1"       # Skips waiting for staggered spin-up on SATA (harmless on NVMe/SSDs)
    "scsi_mod.use_blk_mq=1"      # Forces multi-queue block layer usage for faster storage IOPS
  ];

  # LUKS encrypted root
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
    
    # Speed optimization: Bypass initial hardware cryptographic benchmarking on every boot
    bypassWorkqueues = true;
  };
}
