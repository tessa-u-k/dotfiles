{
  
  description = "Multi-platform Nix configuration";

  inputs = {
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, lix-module, lix }: {

    # NixOS configuration (ThinkPad)
    nixosConfigurations.pennyix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/thinkpad/config.nix
        lix-module.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.penny = import ./home.nix;
        }
      ];
    };

    # macOS configuration (MacBook Pro)
    darwinConfigurations."pennys-studio" = darwin.lib.darwinSystem {
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
