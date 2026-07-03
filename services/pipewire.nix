# ~/nix-btw/services/pipewire.nix
{ config, pkgs, ... }:

{
  # 1. Explicitly isolate and disable legacy audio daemons
  # This prevents any race conditions or device-hogging conflicts with PipeWire
  hardware.pulseaudio.enable = false;

  # 2. RealtimeKit Integration
  # Essential for PipeWire to request high-priority CPU scheduling dynamically,
  # ensuring flawless, crackle-free audio even under heavy system or gaming loads.
  security.rtkit.enable = true;

  # 3. Core PipeWire Architecture Configuration
  services.pipewire = {
    enable = true;
    
    # Enable ALSA infrastructure mapping
    alsa.enable = true;
    alsa.support32Bit = true; # Critical for 32-bit legacy apps and Steam gaming compatibility
    
    # Enable PulseAudio compatibility abstraction layer
    # This acts as a drop-in replacement server for the vast majority of modern desktop apps
    pulse.enable = true;

    # Enable JACK compatibility layer
    # Guarantees out-of-the-box support for professional audio/music production tooling
    jack.enable = true;
  };

  # 4. Standard Professional Diagnostic & Level Controls
  # Installs essential terminal and GUI tools to manage volume nodes natively
  environment.systemPackages = with pkgs; [
    pulsemixer  # Clean, lightweight terminal-based audio mixer
    pavucontrol # Full-featured graphical interface for complex hardware routing
  ];
}
