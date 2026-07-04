# ~/nix-btw/users/senku-btw/profile.nix
{ config, pkgs, ... }:

{
  users.users.senku-btw = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"           # Allows sudo access
      "networkmanager"  # Allows managing network connections
      "audio"           # Direct access to audio devices (alsa/jack fallback)
      "video"           # Direct access to webcam and GPU hardware acceleration
      "input"           # Access to input devices (useful for certain controllers/utilities)
      "render"          # Access for graphics rendering (crucial for modern gaming/GPU compute)
    ];
    openssh.authorizedKeys.keys = [];
  };
}
