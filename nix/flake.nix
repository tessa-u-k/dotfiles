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

    # Per-model hardware quirks; used for the Framework 16.
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Driver for the ThinkPad's Synaptics 06cb:009a fingerprint reader.
    # Deliberately not following nixpkgs: its python-validity package is
    # built against the flake's own pinned nixpkgs (unstable isn't supported).
    # Fork of ahbnr/nixos-06cb-009a-fingerprint-sensor (24.11) with a fix that
    # stops python-validity before sleep (the sensor re-enumerates on wake).
    # Run `nix flake update nixos-06cb-009a-fingerprint-sensor` after changing it.
    nixos-06cb-009a-fingerprint-sensor.url = "github:tessa-u-k/nixos-06cb-009a-fingerprint-sensor/fix-resume-lockscreen-race";

    # TUI MeshCore client, built from the fork's flake (home.nix installs it).
    # Follows nixpkgs: it needs python3Packages.meshcore, which is in unstable.
    # Run `nix flake update meshterm` to pick up new commits.
    meshterm = {
      url = "github:tessa-u-k/MeshTerm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The private ABDL fork of claude-mommy (home.nix builds its package.nix
    # with the words set there). Not a flake input in the usual sense: only
    # the source is used. Fetched over SSH, so locking or updating it needs
    # your key. Run `nix flake update claude-mommy-abdl` to pick up new commits.
    claude-mommy-abdl = {
      url = "git+ssh://git@git.klbr.mom/tessa-u-k/claude-mommy-abdl";
      flake = false;
    };

    # Packages the paid Binary Ninja editions from an installer zip you add to
    # the Nix store yourself (see pkgs/binary-ninja.nix).
    # Run `nix flake update binaryninja` to pick up new Binary Ninja releases.
    binaryninja = {
      url = "github:jchv/nix-binary-ninja";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      nixos-hardware,
      nixos-06cb-009a-fingerprint-sensor,
      meshterm,
      claude-mommy-abdl,
      binaryninja,
      ...
    }:

    {
      nixosConfigurations.pennyix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/thinkpad/config.nix
          nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
          { nixpkgs.overlays = [ binaryninja.overlays.default ]; } # pkgs.binary-ninja
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit meshterm claude-mommy-abdl; };

            home-manager.users.penny = import ./home.nix;
          }
        ];
      };

      nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/framework/config.nix
          nixos-hardware.nixosModules.framework-16-7040-amd
          { nixpkgs.overlays = [ binaryninja.overlays.default ]; } # pkgs.binary-ninja
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit meshterm claude-mommy-abdl; };

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
            home-manager.extraSpecialArgs = { inherit meshterm claude-mommy-abdl; };

            home-manager.users.penny = import ./home.nix;
          }
        ];
      };

      # `nix run .#fetch-binaryninja`: download the licensed Binary Ninja
      # installer (serial read from license.dat) and add it to the Nix store.
      packages.x86_64-linux.fetch-binaryninja =
        let
          system = self.nixosConfigurations.pennyix;
        in
        system.pkgs.callPackage ./pkgs/fetch-binaryninja.nix {
          inherit (system.pkgs.callPackage ./pkgs/binary-ninja.nix { }) src;
          nix = system.config.nix.package; # the same Lix the system runs
        };

      # `nix build .#binary-ninja`: the same package the ThinkPad installs.
      packages.x86_64-linux.binary-ninja =
        self.nixosConfigurations.pennyix.pkgs.callPackage ./pkgs/binary-ninja.nix
          { };

      # `nix build .#wrangler`: the newer wrangler home.nix installs (used when
      # bumping pkgs/wrangler.nix to get the new hashes).
      packages.x86_64-linux.wrangler =
        nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/wrangler.nix
          { };
      packages.aarch64-darwin.wrangler =
        nixpkgs.legacyPackages.aarch64-darwin.callPackage ./pkgs/wrangler.nix
          { };

      # `nix fmt` formats every .nix file in the repo.
      formatter = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );
    };
}
