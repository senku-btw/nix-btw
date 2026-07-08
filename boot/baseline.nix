{ config, lib, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the XanMod kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Plymouth graphical boot splash
  boot.plymouth.enable = true;

  # Use systemd in the initrd for seamless Plymouth + LUKS integration
  boot.initrd.systemd.enable = true;

  # Silence boot output as much as possible
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false; # Fix 1: Completely silences NixOS stage-1 script echo loops

  boot.kernelParams = [
    # General
    "quiet"
    "splash"

    # Kernel logging
    "loglevel=0"
    "printk.devkmsg=off"

    # Hide systemd status messages
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "systemd.log_level=err" # Fix 2: Changed from notice to err to catch hidden systemd unit fault dumps

    # Reduce udev logging
    "udev.log_level=0" # Fix 3: Lowered to 0 so early hardware discovery won't dump alerts
    "rd.udev.log_level=0"

    # Suppress ACPI interpreter errors where possible
    "acpi.log_errors=0"
    "vt.global_cursor_default=0" # Fix 4: Ensures no blinking cursor cuts through the Plymouth splash screen
  ];

  # LUKS encrypted root
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
  };
}
