{
  description = "Multi-platform Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    # Fork of ahbnr/nixos-06cb-009a-fingerprint-sensor (24.11) with a fix that
    # stops python-validity before sleep (the sensor re-enumerates on wake).
    # Run `nix flake update nixos-06cb-009a-fingerprint-sensor` after changing it.
    nixos-06cb-009a-fingerprint-sensor.url = "github:tessa-u-k/nixos-06cb-009a-fingerprint-sensor/fix-resume-lockscreen-race";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      nixos-06cb-009a-fingerprint-sensor,
      ...
    }:

    {
      nixosConfigurations.pennyix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/thinkpad/config.nix
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

          ./hosts/darwin/mac-mini.nix

          home-manager.darwinModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.penny = import ./home.nix;
          }
        ];
      };

      # `nix fmt` formats every .nix file in the repo.
      formatter = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );
    };
}
