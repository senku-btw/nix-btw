{ pkgs, ... }:

{
  # Wrap this in a config block to tell Nix this is implementation metadata
  config = {
    # Desktop Applications (user-space)
    home.packages = [
      pkgs.google-chrome  # Web browser (Standard Chromium-based)
      pkgs.keepassxc      # Password Manager (Offline, encrypted local-only vault)
      pkgs.min            # Web browser (Minimalist, privacy-focused)
      pkgs.nautilus       # File Manager (GNOME core utility)
      pkgs.obsidian       # Markdown Editor (Knowledge base)
    ];
  };
}
