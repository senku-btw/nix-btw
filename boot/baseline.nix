# ~/nix-btw/boot/baseline.nix
{ config, lib, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # LUKS encrypted root
  boot.initrd.luks.devices."enc-pv" = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
    bypassWorkqueues = true;
  };
  
  # Speed optimization: Instant bypass of the boot menu
  boot.loader.timeout = 0;

  # Use the XanMod kernel 
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Use systemd in the initrd 
  boot.initrd.systemd.enable = true;
  
  # Silence NixOS internal stage-1/stage-2 text wrappers completely
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false; 

  boot.kernelParams = [
    "quiet"
    "loglevel=0"
    "printk.devkmsg=off"
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "systemd.log_level=err" 
    "udev.log_level=0" 
    "rd.udev.log_level=0"
    "acpi.log_errors=0"
    "vt.global_cursor_default=0"
    "fastboot"                   
    "libahci.ignore_sss=1"       
    "lp=0"                       
    "io_delay=none"              
    "noatime"                    
    "fbcon=nodefer"              
  ];
}
