{ config, lib, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the XanMod kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # REMOVED: boot.plymouth.enable = true (Keeps the system minimal)

  # Use systemd in the initrd for robust, modern LUKS terminal handling
  boot.initrd.systemd.enable = true;

  # Silence boot output completely
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false; 

  boot.kernelParams = [
    # General (Mutes standard text output channels)
    "quiet"
    "nomodeset"                   # Optional: Prevents early frame-buffer shifts that flash text cached by firmware

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
    "vt.global_cursor_default=0" # Keeps the blinking cursor from flashing on the black screen
  ];

  # LUKS encrypted root
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
  };
}
