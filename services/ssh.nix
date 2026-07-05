# ~/nix-btw/services/ssh.nix
{ config, pkgs, ... }:

{
  # Enable GnuPG agent without hijacking SSH keys authentication
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false; # Set to false so it doesn't conflict with Home Manager's ssh-agent
  };

  # Secure OpenSSH daemon infrastructure configuration
  # This automatically runs at system launch!
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; 
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };
}
