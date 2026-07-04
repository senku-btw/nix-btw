# ~/nix-btw/users/senku-btw/self.nix
{ config, pkgs, ... }:

{
  users.users.senku-btw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [];
  };
}
