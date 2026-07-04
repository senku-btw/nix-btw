# ~/nix-btw/users/senku-btw/user-packages.nix
{ config, pkgs, ... }:

{
  users.users.senku-btw.packages = with pkgs; [
    fastfetch
    pavucontrol
  ];
}
