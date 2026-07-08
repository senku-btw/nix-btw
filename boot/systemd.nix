# ~/nix-btw/boot/systemd.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader Architecture
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
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

  # Initrd & systemd streamlining (Extreme minimalism)
  boot.initrd.systemd.enable = true;
  boot.initrd.compressor = "zstd -1"; 
  
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

  # Mask heavy or irrelevant early hardware debugging tasks
  systemd.maskedServices = [
    "sys-kernel-debug.mount"
    "dev-hugepages.mount"
  ];

  # Absolute error suppression & total black screen silence
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false; 

  boot.kernelParams = [
    "quiet"                                 # Suppress standard boot messages
    "loglevel=0"                            # Log only critical kernel emergencies
    "printk.devkmsg=off"                    # Disable early console dmesg logging
    "systemd.show_status=auto"              # Hide systemd service status dumps
    "rd.systemd.show_status=auto"          # Hide status dumps in initial RAMdisk
    "systemd.log_level=err"                 # Restrict systemd logging to errors
    "udev.log_level=0"                      # Disable hardware discovery logging
    "rd.udev.log_level=0"                   # Disable initrd hardware discovery logs
    "acpi.log_errors=0"                     # Mask non-fatal motherboard ACPI errors
    "vt.global_cursor_default=0"            # Disable blinking console cursor
    "fastboot"                              # Skip storage topology self-tests
    "libahci.ignore_sss=1"                  # Disable staggered SATA spin-up delays
    "lp=0"                                  # Skip legacy parallel port probing
    "io_delay=none"                         # Disable legacy x86 ISA timing delays
    "noatime"                               # Redundant mount flag, safe to ignore
    "fbcon=nodefer"                         # Defer framebuffer for clean LUKS prompt
    "cryptomgr.notests"                     # Skip crypto self-tests during boot
    "nvme_core.default_ps_max_latency_us=0" # Force max-performance NVMe state
    "mce=off"                               # Suppress Machine Check Exception errors
    "warn_alloc=off"                        # Suppress page allocation warnings
    "video=efifb:off"                       # Kill early EFI text framebuffers entirely
  ];

  boot.kernelParams = [
  "quiet"
  "loglevel=3"
  "printk.devkmsg=off"
  "systemd.show_status=auto"
  "rd.systemd.show_status=auto"
  "systemd.log_level=err"
  "vt.global_cursor_default=0"
  "nvme_core.default_ps_max_latency_us=0"
  "libahci.ignore_sss=1"
  "fastboot"
  "io_delay=none"
  "cryptomgr.notests"
  "fbcon=nodefer"
  "acpi.log_errors=0"
 ];

  # High-performance runtime storage (Aggressive Btrfs tuning)
  fileSystems."/" = {
    fsType = "btrfs";
    options = [ 
      "subvol=@" 
      "noatime"           # Disable access time updates
      "discard=async"     # Asynchronous background SSD TRIM
      "space_cache=v2"    # Fast free space tracking
      "compress=zstd:1"   # Ultra-fast, low-overhead compression
    ];
  };
}
