# ~/nix-btw/services/ssh.nix
{ config, pkgs, ... }:

{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; 
      KbdInteractiveAuthentication = true;
    };
  };
}
