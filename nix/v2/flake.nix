# flake.nix
{
  description = "Multi-platform Nix configuration for NixOS and macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin }: 
    let
      # Shared user configuration
      userName = "angel";
      userEmail = "angel@klbr.mom";
    in
    {
      # NixOS configuration (ThinkPad)
      nixosConfigurations.pennyix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pennyix/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.penny = import ./home/linux.nix;
            home-manager.extraSpecialArgs = { inherit userName userEmail; };
          }
        ];
      };

      # macOS configuration
      darwinConfigurations.macbook = darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # or "x86_64-darwin" if Intel Mac
        modules = [
          ./hosts/macbook/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.angel = import ./home/darwin.nix;
            home-manager.extraSpecialArgs = { inherit userName userEmail; };
          }
        ];
      };
    };
}
