{
  description = "Multi-platform Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin }: {
    # NixOS configuration (ThinkPad)
    nixosConfigurations.pennyix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nixos/config.nix
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.penny = import ./home.nix;
        }
      ];
    };

    # macOS configuration (MacBook Pro)
    darwinConfigurations."pennys-MacBook-Pro" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ({ ... }: { nixpkgs.hostPlatform = "aarch64-darwin"; })
        ({ ... }: { _module.args.self = self; })
        ./hosts/darwin/macbook.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.penny = import ./home.nix;
        }
      ];
    };
  };
}
