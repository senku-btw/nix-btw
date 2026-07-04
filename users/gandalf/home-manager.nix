# ~/nix-btw/users/gandalf/home-manager.nix
{ config, pkgs, ... }:

{
  # Core Home Manager profile identity
  home.username = "senku-btw";
  home.homeDirectory = "/home/senku-btw";
  
  # Tracks the initial installation release state for stateful data compatibility
  home.stateVersion = "24.11"; 

  # Let Home Manager manage itself natively
  programs.home-manager.enable = true;

  # User-space software packages
  home.packages = with pkgs; [
    # Audio volume control interface
    pavucontrol
    
    # Modern GPU-accelerated terminal emulator
    alacritty
    
    # Lightweight, fast Wayland-native application launcher
    bemenu
  ];

  # Out-of-store development symlinks referencing your local dotfiles repository
  home.file = {
    # Direct symlink for Niri window manager layout definitions
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/niri/config.kdl";
    
    # Direct symlink for Bemenu menu interface options
    ".config/bemenu/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/bemenu/config";
  };
}
