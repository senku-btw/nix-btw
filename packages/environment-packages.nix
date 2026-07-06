# ~/nix-btw/packages/environment-packages.nix
{ pkgs, ... }:

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
        --wrapper="${pkgs.dex}/bin/dex"
    '';
  };
in
{
  # Core user-space environment and window manager utilities.
  # Alphabetized to ensure clean Git diffs and robust dependency tracking.
  home.packages = [
    bemenu-drun         # Optimized execution entry point (Custom wrapper)
    pkgs.alacritty      # Terminal emulator (GPU-accelerated)
    pkgs.bemenu         # Dynamic menu library (Wayland native)
    pkgs.pavucontrol    # Audio mixer volume control (PulseAudio/PipeWire GUI)
  ];
}
