# ~/nix-btw/users/gandalf/home-manager.nix
{ config, pkgs, ... }:

let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles/config";

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
  # Core Home Manager profile identity
  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  home.stateVersion = "24.11"; 

  # Let Home Manager manage itself natively
  programs.home-manager.enable = true;

  # Lightweight performance-first software packaging
  home.packages = [
    pkgs.bemenu            # Installs compiled core library & binaries
    pkgs.j4-dmenu-desktop  # Blazing fast C++ desktop database entry crawler
    pkgs.dex               # Microsecond-level desktop launch translation utility
    bemenu-drun           # High-efficiency immutable launcher binary
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
