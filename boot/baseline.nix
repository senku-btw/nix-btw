# ~/nix-btw/boot/baseline.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Speed optimization: Instant bypass of the boot menu
  boot.loader.timeout = 0;

  # Use the XanMod kernel (excellent choice for desktop responsiveness)
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Use systemd in the initrd for robust, parallelized service execution
  boot.initrd.systemd.enable = true;

  # Speed optimization: Swap default compression to LZ4 for ultra-fast initrd decompression
  boot.initrd.compression = "lz4";

  # Silence NixOS internal stage-1/stage-2 text wrappers completely
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false; 

  boot.kernelParams = [
    # General (Mutes standard text output channels)
    "quiet"

    # Kernel logging (Emergency only, no tracking buffers displayed)
    "loglevel=0"
    "printk.devkmsg=off"

    # Hide systemd status messages and cut log levels to standard faults
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "systemd.log_level=err" 

    # Reduce udev hardware population engine alerts
    "udev.log_level=0" 
    "rd.udev.log_level=0"

    # Suppress ACPI interpreter errors completely and squash blinking cursors
    "acpi.log_errors=0"
    "vt.global_cursor_default=0"
    
    # Storage velocity optimizations
    "fastboot"                   # Skips non-essential storage geometry self-tests
    "libahci.ignore_sss=1"       # Disables staggered spin-up loops on standard controllers
    
    # Hardcore Speed Optimizations: Skip legacy hardware probing entirely
    "lp=0"                       # Disables parallel port probing loops
    "io_delay=none"              # Removes legacy ISA I/O port 0x80 small delays
    "noatime"                    # Cuts file mapping time checks

    # SAFE Visual Suppression: Delays video mode switching until the last possible second
    "fbcon=nodefer"              
  ];

  # LUKS encrypted root
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
    
    # Speed optimization: Direct execution handling bypassing the workqueue overhead
    bypassWorkqueues = true;
  };
}
