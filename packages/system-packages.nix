# ~/nix-btw/packages/system-packages.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nano
    wget
    git
    tree
    fastfetch
    pavucontrol
  ];
}
