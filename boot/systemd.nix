# ~/nix-btw/boot/systemd.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader Architecture
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  # LUKS Encrypted Container initialization
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
    bypassWorkqueues = true; # Direct crypto execution, bypassing CPU workqueue lag
  };

  # Recommended for maximum stability on production workstations
  boot.kernelPackages = pkgs.linuxPackages_LTS;

  # Instantly boots the default generation without showing the menu
  boot.loader.timeout = 0;

  # Initrd & systemd streamlining (minimalism)
  boot.initrd.systemd.enable = true;

  # Prevent asynchronous service checks from blocking your desktop login target
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-udev-settle.enable = false;

  # Absolute error suppression & silence
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false; 

  boot.kernelParams = [
    "quiet"                         # Suppress standard boot messages
    "loglevel=0"                    # Only log critical kernel emergencies
    "printk.devkmsg=off"            # Silence early kernel dmesg logging to console
    "systemd.show_status=false"     # Hide systemd service status dumps
    "rd.systemd.show_status=false"  # Hide systemd status dumps in initrd
    "systemd.log_level=err"         # Limit systemd logging to errors only
    "udev.log_level=0"              # Silence hardware discovery logging
    "rd.udev.log_level=0"           # Silence initrd hardware discovery logging
    "acpi.log_errors=0"             # Mask non-fatal motherboard ACPI errors
    "vt.global_cursor_default=0"    # Disable blinking console cursor
    "fastboot"                      # Skip storage topology self-tests
    "libahci.ignore_sss=1"          # Disable staggered spin-up delays for SATA
    "lp=0"                          # Skip legacy parallel port probing
    "io_delay=none"                 # Disable legacy x86 ISA bus timing delays
    "noatime"                       # Redundant mount flag, safe to ignore
    "fbcon=nodefer"                 # Defer framebuffer initialization for clean LUKS prompt
  ];

  # High-performance runtime storage (Btrfs tuning)
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
