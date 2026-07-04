# ~/nix-btw/users/senku-btw/home-manager.nix
{ config, pkgs, ... }:

{
  home.username = "senku-btw";
  home.homeDirectory = "/home/senku-btw";
  home.stateVersion = "24.05"; 

  programs.home-manager.enable = true;

  # Create out-of-store developer links directly into your dotfiles tracking folder
  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/niri/config.kdl";
    
    # Symlink Fuzzel configuration directly from your local .dotfiles repository
    ".config/fuzzel/fuzzel.ini".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/fuzzel/fuzzel.ini";
  };
}
