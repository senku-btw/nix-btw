# ~/nix-btw/users/gandalf/home-manager.nix
{ config, pkgs, ... }:

let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles/config";

  # Robust, production-grade Wayland launcher wrapper
  bemenu-drun = pkgs.writeShellScriptBin "bemenu-drun" ''
    set -euo pipefail

    # Execute j4-dmenu-desktop natively inside Wayland using dex
    exec ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
      --dmenu="${pkgs.bemenu}/bin/bemenu" \
      --term="${pkgs.alacritty}/bin/alacritty" \
      --wrapper="${pkgs.dex}/bin/dex"
  '';
in
{
  # Core Home Manager profile identity
  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  home.stateVersion = "24.11"; 

  # Let Home Manager manage itself natively
  programs.home-manager.enable = true;

  # User-space software packages
  home.packages = with pkgs; [
    pavucontrol
    alacritty
    bemenu            # Core binary utilities
    j4-dmenu-desktop  # High-performance .desktop parser
    dex               # Native XDG execution handler for Wayland
    bemenu-drun       # Our immutable, production-grade wrapper script
  ];

  # Start the SSH Agent automatically upon user sign-in
  services.ssh-agent.enable = true;

  # Enterprise Standard: Unified, warning-free SSH configuration block
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; 
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/pandora";
      };
    };
  };

  # Out-of-store development symlinks referencing your local dotfiles repository
  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/niri/config.kdl";
    ".config/bemenu/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/bemenu/config";
  };
}
