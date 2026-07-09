# ~/nix-btw/boot/systemd.nix
{ config, lib, pkgs, ... }:

{
  # --- Bootloader Architecture ---
  # Enables systemd-boot as the primary EFI boot manager
  boot.loader.systemd-boot.enable = true;

  # Disables the systemd-boot kernel parameter editor to prevent unauthorized modifications at boot
  boot.loader.systemd-boot.editor = false;

  # Allows NixOS to modify EFI variables so it can update boot entries when generations change
  boot.loader.efi.canTouchEfiVariables = true;
 
  # --- LUKS Encrypted Container Initialization ---
  boot.initrd.luks.devices."enc-pv" = {
    # Specifies the physical NVMe partition housing the encrypted LUKS container
    device = "/dev/nvme0n1p2";

    # Discovers and opens the cryptographic volume before initializing LVM/file systems
    preLVM = true;

    # Enables block discard (TRIM) pass-through, preserving NVMe performance and flash longevity
    allowDiscards = true;

    # Bypasses system crypt workqueues to execute inline encryption directly on the CPU cryptographic cores (reduces NVMe latency)
    bypassWorkqueues = true;
  };

  # Selects the Long-Term Support kernel for maximum driver stability and predictability
  boot.kernelPackages = pkgs.linuxPackages_LTS;

  # Provides a brief 2-second window to press a key and access older generations if a boot failure occurs
  boot.loader.timeout = 2;

  # --- Initrd & Systemd Streamlining ---
  # Utilizes systemd instead of legacy script-based architectures inside the initial ramdisk (initrd)
  boot.initrd.systemd.enable = true;

  # Selects ZSTD as the initrd compression algorithm for high-speed decompression overhead
  boot.initrd.compressor = "zstd"; 

  # Passes the fastest compression level (-1) to ZSTD to optimize builder performance without impacting boot times
  boot.initrd.compressorArgs = [ "-1" ]; 
  
  # Disables loading the massive default suite of generic drivers to drastically shrink initrd size
  boot.includeDefaultModules = false;

  # Whitelists only the exact storage, host controller, and input drivers required to mount the root FS and enter passphrases
  boot.initrd.availableKernelModules = [
    "nvme"         # NVMe storage driver
    "xhci_pci"     # USB 3.0 host controller driver
    "usbhid"       # USB keyboard/input driver
    "usb_storage"  # USB mass storage support
    "btrfs"        # Root filesystem driver
  ];

  # --- Systemd Service Optimizations ---
  # Prevents boot blocking by refusing to wait for a network handshake before reaching the graphical login target
  systemd.services.NetworkManager-wait-online.enable = false;

  # Disables waiting for cold-plugged udev hardware devices to settle, eliminating a frequent boot stall point
  systemd.services.systemd-udev-settle.enable = false;

  # --- Masked Systemd Units ---
  systemd.maskedServices = [
    # Disables mounting the kernel debugging filesystem (unnecessary for production workstation usage)
    "sys-kernel-debug.mount"

    # Disables runtime kernel configuration infrastructure mounts to minimize surface area
    "sys-kernel-config.mount"

    # Prevents mounting the platform persistent storage space used for legacy panic saves
    "pstore.mount"

    # Stops the automated systemd processing of historical crash records during the early init sequence
    "systemd-pstore.service"
  ];

  # --- Global Systemd Timeouts ---
  systemd.extraConfig = ''
    # Lowers the maximum time systemd will wait for a stalled service to start during boot execution
    DefaultTimeoutStartSec=10s

    # Aggressively forces stubborn or unresponsive applications to terminate within 10 seconds during power-off sequence
    DefaultTimeoutStopSec=10s
  '';

  # --- Journald Log Constraints ---
  services.journald.extraConfig = ''
    # Caps the total on-disk journal footprint to prevent expansive index parsing delays during early boot
    SystemMaxUse=100M

    # Restricts individual log segments to 20MB to force aggressive rotation patterns
    SystemMaxFileSize=20M

    # Instructs systemd to store logs persistently on disk rather than volatile volatile memory
    Storage=persistent
  '';

  # --- Console Logging Constraints ---
  # Limits the physical TTY console display output to level 3 (Errors) and above to keep boot clean
  boot.consoleLogLevel = 3; 

  # Silences structural initrd debugging statements to keep the display stream visually empty
  boot.initrd.verbose = false; 

  # --- Advanced Kernel Parameters ---
  boot.kernelParams = [
    # Suppresses standard kernel informational text during early bootstrap
    "quiet"                                 

    # Filters framework logging to severity level 3 (Errors) to conceal non-critical system notifications
    "loglevel=3"                            

    # Prevents runtime kernel printk messages from flooding the /dev/kmsg stream early on
    "printk.devkmsg=off"                    

    # Configures systemd to output unit status changes dynamically or only on specific structural events
    "systemd.show_status=auto"              

    # Mirrors the conditional status behavior inside the initrd layer
    "rd.systemd.show_status=auto"          

    # Forces systemd core logic to suppress warning strings and output strict errors only
    "systemd.log_level=err"                 

    # Instructs udev infrastructure to hide verbose device discovery logs while preserving error paths
    "udev.log_level=3"                      

    # Extends error-only logging profiles to the initial ramdisk hardware detection loop
    "rd.udev.log_level=3"                    

    # Suppresses continuous firmware/ACPI compatibility warnings that do not impact hardware stability
    "acpi.log_errors=0"                     

    # Disables the flashing text console cursor during early modesetting to ensure a clean visual transition
    "vt.global_cursor_default=0"            

    # Instructs the frame-buffer subsystem to skip legacy driver deferral steps for instant display handoff
    "fbcon=nodefer"                         

    # Commands the kernel to skip non-essential safety checks on storage architectures during discovery
    "fastboot"                              

    # Instructs SATA controllers to ignore staggered spin-up delays (helps avoid artificial hardware alignment pauses)
    "libahci.ignore_sss=1"                  

    # Disables legacy parallel port polling logic
    "lp=0"                                  

    # Erases legacy I/O delays on port 0x80 execution steps to shave milliseconds off CPU cycle waits
    "io_delay=none"                         

    # Locks NVMe storage lanes out of lower energy saving deep sleep levels to completely eradicate power-state transition stutters
    "nvme_core.default_ps_max_latency_us=0" 
  ];

  # --- Runtime Storage Tuning ---
  fileSystems."/" = {
    # Sets the primary filesystem architecture to Btrfs
    fsType = "btrfs";

    options = [ 
      # Selects the subvolume explicitly assigned to handle the root OS environment
      "subvol=@" 

      # Inhibits file metadata update writes when reading files, dramatically limiting unnecessary SSD wear
      "noatime"           

      # Instructs the storage controller to queue block discards (TRIM) asynchronously to ensure zero impact on write operations
      "discard=async"     

      # Utilizes internal free space cache generation v2 for rapid block allocations on heavily populated file spaces
      "space_cache=v2"    

      # Enforces fast ZSTD level-1 transparent compression on all blocks to decrease storage overhead and improve disk reads
      "compress=zstd:1"   
    ];
  };
}
