# ~/nix-btw/boot/baseline.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader & storage architecture (hyper-speed / secure)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Speed optimization: Instant bypass of the systemd-boot menu delay
  boot.loader.timeout = 0;

  # LUKS encrypted root configuration
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
    
    # Speed optimization: Direct crypto execution, bypassing CPU workqueue lag
    bypassWorkqueues = true;
  };

  # Use the XanMod kernel for tier-one desktop responsiveness and scheduling
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Initrd & systemd streamlining (minimalism)
  boot.initrd.systemd.enable = true;

  # Prevent asynchronous service checks from blocking your desktop login target
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-udev-settle.enable = false;

  # Absolute error suppression & silence
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false; 

  boot.kernelParams = [
    # General output suppression
    "quiet"

    # Kernel ring-buffer logging level (Emergency only)
    "loglevel=0"
    "printk.devkmsg=off"

    # Silence systemd framework status and unit tracking dumps
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "systemd.log_level=err" 

    # Silence hardware discovery alerts (udev)
    "udev.log_level=0" 
    "rd.udev.log_level=0"

    # Suppress motherboard firmware/ACPI interpreter glitches
    "acpi.log_errors=0"
    "vt.global_cursor_default=0" # Kills blinking cursor leaking onto dark screen
    
    # Storage and Hardware speed tweaks
    "fastboot"                   # Skips storage topology self-tests
    "libahci.ignore_sss=1"       # Disables staggered spin-up wait loops
    "lp=0"                       # Skips legacy parallel printer port loops
    "io_delay=none"              # Drops legacy x86 hardware ISA timing delay loops
    "noatime"                    # Drops mapping write triggers on file reads
    
    # Keep screen totally dark until the interactive LUKS prompt fires
    "fbcon=nodefer"              
  ];

  # High-performance runtime storage (Btrfs tuning)
  fileSystems."/" = {
    # The absolute device path is safely managed by hardware-configuration.nix
    fsType = "btrfs";
    options = [ 
      "subvol=@" 
      "noatime"       # Eliminates metadata write overhead whenever files are read
      "nodiratime"    # Applies the same read optimization to system directories
      "discard=async" # Uses asynchronous background block trims for NVMe lifespans
      "space_cache=v2"# Uses the high-velocity free space tracking tracking index
    ];
  };

  # Automated housekeeping (keeps boot menu ultra-lightweight)
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d"; # Keeps boot selections clean and fast to parse
  };
}
