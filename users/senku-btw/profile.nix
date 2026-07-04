# ~/nix-btw/users/senku-btw/profile.nix
{ config, pkgs, ... }:

{
  users.users.senku-btw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [];
  };
}
