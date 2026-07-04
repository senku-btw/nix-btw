# ~/nix-btw/services/pipewire.nix
{ config, pkgs, ... }:

{
  # Disable legacy PulseAudio system daemon to prevent hardware resource locking
  services.pulseaudio.enable = false;

  # Enable RealtimeKit for system process priority management (prevents audio crackling)
  security.rtkit.enable = true;

  # Core Pipewire multimedia framework orchestration
  services.pipewire = {
    enable = true;
    
    # Enable ALSA infrastructure translation layer
    alsa.enable = true;
    alsa.support32Bit = true;
    
    # Enable PulseAudio server emulation wrapper
    pulse.enable = true;
    
    # Enable JACK audio server API support
    jack.enable = true;
  };
}
