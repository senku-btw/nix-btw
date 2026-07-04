# ~/nix-btw/flake.nix
{
  description = "Minimalist Enterprise NixOS Configuration Flake";

  inputs = {
    # Main NixOS repository tracking the unstable development branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager tracking development branch, locked to system nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # System derivation for target host 'nix'
    nixosConfigurations."nix" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # Expose flake inputs to downstream modules natively
      specialArgs = { inherit inputs; };
      
      modules = [
        # Global system configuration base
        ./configuration.nix
        
        # Declarative home environment management module
        home-manager.nixosModules.home-manager
        {
          # Inherit system package configuration and options inside home-manager
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
