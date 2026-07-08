# ~/nix-btw/boot/baseline.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader core configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the kernel to Xanmod for optimal desktop performance
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Production-grade kernel parameter optimizations and firmware error suppression
  boot.kernelParams = [ 
    "quiet" 
    "splash" 
    "loglevel=3"        # Suppresses non-critical kernel warnings/errors during boot
    "udev.log_level=3"   # Suppresses hardware/driver initialization warnings
    "acpi.log_errors=0"  # Disables logging of ACPI interpreter errors (like AE_AML_UNINITIALIZED_ELEMENT)
    "vt.global_cursor_default=0" # Prevents a blinking cursor from breaking the splash screen aesthetic
  ];

  # LUKS encrypted volume configuration
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
  };
}
