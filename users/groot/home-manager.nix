# ~/nix-btw/users/groot/home-manager.nix
{ config, pkgs, ... }:

{
  home.username = "groot";
  home.homeDirectory = "/home/groot";
  home.stateVersion = "24.05"; 

  programs.home-manager.enable = true;

  # Create out-of-store developer links directly into your dotfiles tracking folder
  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/groot/.dotfiles/.config/niri/config.kdl";
    
    # Symlink Fuzzel configuration directly from your local .dotfiles repository
    ".config/fuzzel/fuzzel.ini".source = config.lib.file.mkOutOfStoreSymlink "/home/groot/.dotfiles/.config/fuzzel/fuzzel.ini";
  };
}
