# ~/nix-btw/flake.nix
{
  description = "Minimalist Enterprise NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Changed hostName configuration key from "nix-btw" to "nix"
    nixosConfigurations."nix" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        
          home-manager.users.senku-btw = import ./users/senku-btw/home-manager.nix;
        }
      ];
    };
  };
}
