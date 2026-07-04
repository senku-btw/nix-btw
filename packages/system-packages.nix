# ~/nix-btw/packages/system-packages.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core system text editor
    nano

    # Network utilities and data retrieval
    wget
    curl

    # Version control and development essentials
    git

    # System administration and diagnostic utilities
    tree
    fastfetch

    # Desktop integration and mime-type handling
    xdg-utils
  ];
}
