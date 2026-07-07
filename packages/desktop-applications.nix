{ pkgs, ... }:

{
  home.packages = [
    pkgs.google-chrome
    pkgs.keepassxc
    pkgs.min
    pkgs.nautilus
    pkgs.obsidian
  ];
}
