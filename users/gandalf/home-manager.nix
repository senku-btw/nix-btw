# ~/nix-btw/users/gandalf/home-manager.nix
{ config, pkgs, ... }:

{
  imports = [
    # Appends user-space application and environment modules
    ../../packages/desktop-applications.nix
    ../../packages/environment-packages.nix
  ];

  # Target Environment Context
  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  home.stateVersion = "24.11"; 

  # Core Service State
  programs.home-manager.enable = true;

  # Runtime Environment Dotfiles (Maintained per out-of-store constraint)
  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/niri/config.kdl";
    ".config/bemenu/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/bemenu/config";
  };

  # Cryptographic Identity Subsystem
  services.ssh-agent.enable = true;

  # Secure Remote Shell Architecture: Hardened Paranoid Posture
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # Hardens security posture by rejecting ambient system configurations
    settings = {
      "*" = {
        # Automates key unlocking while mitigating long-term memory exploitation.
        # Key automatically evicts after 1 hour to prevent indefinite ambient agent access if compromised.
        AddKeysToAgent = "1h"; 
        IdentityFile = "~/.ssh/pandora"; # Enforces a unified cryptokey boundary across hosts
      };
    };
  };
}
