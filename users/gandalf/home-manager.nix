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

    # Hardened, zero-latency execution context.
    # Forces Wayland backend explicitly to completely bypass protocol negotiation overhead.
    text = ''
      export BEMENU_BACKEND="wayland"
      
      exec ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
        --dmenu="${pkgs.bemenu}/bin/bemenu --prompt 'run:'" \
        --term="${pkgs.alacritty}/bin/alacritty" \
        --wrapper="${pkgs.dex}/bin/dex" \
        --fastmode
    '';
  };
in
{
  # Target Environment Context
  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  home.stateVersion = "24.11"; 

  # Core Service State
  programs.home-manager.enable = true;

  # Tailored System Architecture Tools:
  # Retains standalone environment entry points per user specification,
  # while keeping invisible internal utilities (j4-dmenu-desktop, dex) isolated.
  home.packages = [
    pkgs.bemenu       # Retained for general environment usage
    pkgs.alacritty    # Retained for standalone terminal access
    pkgs.pavucontrol  # Retained for standalone audio control
    bemenu-drun      # Optimized execution entry point
  ];

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
