{ config, pkgs, ... }:

let
  # Ultra-low latency, compile-time verified desktop application runner.
  # Utilizes writeShellApplication to enforce ShellCheck validation and strict error handling.
  bemenu-drun = pkgs.writeShellApplication {
    name = "bemenu-drun";
    
    # Explicitly pin runtime dependencies to isolate execution environment.
    runtimeInputs = [ 
      pkgs.j4-dmenu-desktop 
      pkgs.bemenu 
      pkgs.alacritty 
      pkgs.dex 
    ];

    # Absolute-path execution matrix: eliminates PATH crawling lookups and prevents execution hijacking.
    text = ''
      exec ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
        --dmenu="${pkgs.bemenu}/bin/bemenu --prompt 'run:'" \
        --term="${pkgs.alacritty}/bin/alacritty" \
        --wrapper="${pkgs.dex}/bin/dex" \
        --fastmode
    '';
  };
in
{
  # Target Environment Context: Configures identity parameters and evaluation baselines.
  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  home.stateVersion = "24.11"; 

  # Core Service State: Enables declarative user environment lifecycle management.
  programs.home-manager.enable = true;

  # Declared System Architecture Tools: Explicit dependency injection into the user profile.
  home.packages = [
    pkgs.bemenu             # Native Wayland dynamic menu
    pkgs.alacritty          # GPU-accelerated terminal emulator
    pkgs.pavucontrol        # PulseAudio/PipeWire volume control interface
    pkgs.j4-dmenu-desktop   # High-performance desktop entry parser (C++)
    pkgs.dex                # Desktop Entry Execution utility
    bemenu-drun             # Optimized execution entry point
  ];

  # Runtime Environment Dotfiles: Maps mutable file system entries to dotfile sources.
  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/niri/config.kdl";
    ".config/bemenu/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/bemenu/config";
  };

  # Cryptographic Identity Subsystem: Spawns the background authentication key management daemon.
  services.ssh-agent.enable = true;

  # Secure Remote Shell Architecture: Configures transport policies, sandboxing, and identity scopes.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # Hardens security posture by rejecting ambient system configurations
    settings = {
      "*" = {
        AddKeysToAgent = "yes";    # Automates key unlocking to eliminate interactive prompt overhead
        IdentityFile = "~/.ssh/pandora"; # Enforces a unified cryptokey boundary across hosts
      };
    };
  };
}
