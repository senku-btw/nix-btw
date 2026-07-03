# ~/nix-btw/services/wireplumber-rules.nix
{ config, pkgs, ... }:

{
  services.pipewire.wireplumber = {
    enable = true;
    extraConfig = {
      # Rule 1: Set Pro-Audio Profile and boost device priority
      "51-pro-audio-preferred" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_card.pci-0000_08_00.1"; } ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
                "device.priority" = 10000;
              };
            };
          }
        ];
      };

      # Rule 2: Prune/Disable unused ALSA audio outputs 8 and 9
      "54-disable-pro-sinks" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "alsa_output.pci-0000_08_00.1.pro-output-8"; }
              { "node.name" = "alsa_output.pci-0000_08_00.1.pro-output-9"; }
            ];
            actions = {
              update-props = { "node.disabled" = true; };
            };
          }
        ];
      };
    };
  };
}
