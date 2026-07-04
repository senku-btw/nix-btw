# ~/nix-btw/services/ssh.nix
{ config, pkgs, ... }:

{
  # Enable GnuPG agent with integrated SSH keys authentication support
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Secure OpenSSH daemon infrastructure configuration
  services.openssh = {
    enable = true;
    settings = {
      # Disable administrative root login access over network entrypoints
      PermitRootLogin = "no";
      
      # Retain basic password mechanics if required for fallback
      PasswordAuthentication = true; 
      
      # Standard modern naming convention replacement for KbdInteractiveAuthentication
      KVMInteractiveAuthentication = false;
      
      # Enterprise Hardening: Prevent graphical display forwarding channels
      X11Forwarding = false;
    };
  };
}
