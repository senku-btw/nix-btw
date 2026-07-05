# ~/nix-btw/users/gandalf/home-manager.nix
{ config, pkgs, ... }:

{
  # Core Home Manager profile identity
  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  
  # Tracks the initial installation release state for stateful data compatibility
  home.stateVersion = "24.11"; 

  # Let Home Manager manage itself natively
  programs.home-manager.enable = true;

  # User-space software packages
  home.packages = with pkgs; [
    pavucontrol
    alacritty
    bemenu
  ];

  # 1. Start the SSH Agent automatically upon user sign-in
  services.ssh-agent.enable = true;

  # 2. Configure SSH to automatically load your "pandora" key
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes"; # Automatically add keys to the running agent on first use
    matchBlocks = {
      "*" = {
        # Tells SSH to look for your specific private key file
        identityFile = "~/.ssh/pandora"; 
      };
    };
  };

  # Out-of-store development symlinks referencing your local dotfiles repository
  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/niri/config.kdl";
    ".config/bemenu/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/bemenu/config";
  };
}
