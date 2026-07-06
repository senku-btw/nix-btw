# ~/nix-btw/packages/desktop-applications.nix
{ pkgs, ... }:

{
  # Desktop applications
  home.packages = with pkgs; [
    google-chrome   # Web browser
    nautilus        # File Manager (GNOME based)
    min             # Minimalist Web browser
    keepassxc       # Password Manager
    obsidian        # Markdown Editor
  ];
}
