{ config, pkgs, ... }:

let
  # Highly optimized, zero-overhead execution loop
  bemenu-drun = pkgs.writeShellScriptBin "bemenu-drun" ''
    set -efuo pipefail

    # Absolute-path execution matrix: removes lookup latency ($PATH crawls)
    exec ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
      --dmenu="${pkgs.bemenu}/bin/bemenu --prompt 'run:'" \
      --term="${pkgs.alacritty}/bin/alacritty" \
      --wrapper="${pkgs.dex}/bin/dex" \
      --fastmode
  '';
in
{
  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  home.stateVersion = "24.11"; 

  programs.home-manager.enable = true;

  # Core applications, tools, and wrappers available globally
  home.packages = [
    pkgs.bemenu
    pkgs.alacritty        # High-performance, GPU-accelerated terminal emulator
    pkgs.pavucontrol      # PulseAudio/PipeWire volume control GUI
    pkgs.j4-dmenu-desktop # Blazing fast C++ desktop entry crawler available in PATH
    pkgs.dex              # Desktop launch translation utility available in PATH
    bemenu-drun
  ];

  # Out-of-store symlinks for runtime mutability
  home.file = {
    # Niri configuration symlink
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/niri/config.kdl";

    # Bemenu configuration symlink
    ".config/bemenu/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/bemenu/config";
  };

  services.ssh-agent.enable = true;

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
}
