{ pkgs, ... }:

let
  bemenu-drun = pkgs.writeShellApplication {
    name = "bemenu-drun";
    runtimeInputs = [ 
      pkgs.j4-dmenu-desktop 
      pkgs.bemenu 
      pkgs.alacritty 
      pkgs.dex
    ];
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
  home.packages = [
    bemenu-drun
    pkgs.alacritty
    pkgs.bemenu
    pkgs.pavucontrol
  ];
}
