# ~/nix-btw/users/senku/home-manager.nix
{ config, pkgs, lib, ... }:

let
  cfg = config.profiles.senku;
in
{
  # External module composition
  imports = [
    ../../packages/desktop-applications.nix
    ../../packages/environment-packages.nix
  ];

  # Module option declarations
  options.profiles.senku = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "senku";
    };
    dotfilesDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/dotfiles";
    };
  };

  # User profile and state configuration
  home = {
    username = cfg.username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${cfg.username}" else "/home/${cfg.username}";
    stateVersion = "24.11";
  };

  # Home Manager service activation
  programs.home-manager.enable = true;

  # Out-of-store dotfile symlinks
  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfilesDir}/config/niri/config.kdl";
    ".config/bemenu/config".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfilesDir}/config/bemenu/config";
  };

  # SSH agent service activation
  services.ssh-agent.enable = true;

  # Hardened SSH client configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    compression = true;

    # Host matching and connection rules
    matchBlocks = {
      "*" = {
        identityFile = [ "${config.home.homeDirectory}/.ssh/pandora" ];
        extraOptions = {
          "AddKeysToAgent" = "1h";
          "IdentitiesOnly" = "yes";
          "ServerAliveInterval" = "60";
          "ServerAliveCountMax" = "3";
        };
      };
    };
  };
}
