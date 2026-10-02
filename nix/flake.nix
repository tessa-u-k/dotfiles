{
  description = "Multi-platform Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    # Driver for the ThinkPad's Synaptics 06cb:009a fingerprint reader.
    # Deliberately not following nixpkgs: its python-validity package is
    # built against the flake's own pinned nixpkgs (unstable isn't supported).
    nixos-06cb-009a-fingerprint-sensor.url =
      "github:ahbnr/nixos-06cb-009a-fingerprint-sensor?ref=24.11";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , lix-module
    , lix
    , nixos-06cb-009a-fingerprint-sensor
    , ...
    }:

    {
      nixosConfigurations.pennyix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/thinkpad/config.nix
          lix-module.nixosModules.default
          nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.penny = import ./home.nix;
          }
        ];
      };

      darwinConfigurations."cinders-Mac-Mini" = darwin.lib.darwinSystem {
        modules = [
          { nixpkgs.hostPlatform = "aarch64-darwin"; }
          { _module.args.self = self; }

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
