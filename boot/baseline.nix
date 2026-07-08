# ~/nix-btw/boot/baseline.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader core configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the kernel to Xanmod for optimal desktop performance
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Production-grade aggressive boot silencing parameters
  boot.kernelParams = [ 
    "quiet" 
    "splash" 
    "loglevel=2"                  # Dropped to 2 (Critical) so non-halting firmware aborts are entirely hidden
    "udev.log_level=3"
    "acpi.log_errors=0"           # Silences internal ACPI interpreter errors
    "acpi_osi=Linux"              # Informs the firmware to mimic Linux behavior, bypassing standard Windows-only bugs
    "systemd.show_status=false"   # Silences standard systemd service initialization logs
    "rd.systemd.show_status=false"# Silences systemd initialization inside the initial ramdisk (initrd)
    "rd.udev.log_level=3"         # Suppresses hardware alerts inside the initrd before the main system mounts
    "vt.global_cursor_default=0"  # Hides blinking cursor to prevent graphical flicker
  ];

  # LUKS encrypted volume configuration
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
  };
}
