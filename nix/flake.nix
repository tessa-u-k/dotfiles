{
  description = "Example nix-darwin system flake with Lix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
 };
  outputs = inputs@{ self, home-manager, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # Use Lix from nixpkgs (recommended for stable)
      nix.package = pkgs.lixPackageSets.stable.lix;
      
      # List packages installed in system profile
      environment.systemPackages = with pkgs;
        [
          neovim
          ollama
          python313
	      tree-sitter
        ];
      homebrew.enable = true;	
      homebrew.onActivation.cleanup = "uninstall";
      homebrew.onActivation.upgrade = true;
      homebrew.casks = [
        "bambu-studio"
        "google-chrome"
        "ableton-live-suite"
        "keepassxc"
        "kicad"
        "zen"
        "vesktop"
        "transmission"
        "signal"
        "prismlauncher"
        "battle-net"
        "wowup"
        "webex"
        "splice"
        "focusrite-control-2"
        "iterm2"
        "runelite"
        "steam"
      ];
      services.trezord.enable = true;
      services.tailscale.enable = true;
      services.tailscale.overrideLocalDns = true;
      # Create a launchd service for Ollama
      launchd.user.agents.ollama = {
        serviceConfig = {
          ProgramArguments = [ "${pkgs.ollama}/bin/ollama" "serve" ];
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/ollama.log";
          StandardErrorPath = "/tmp/ollama.error.log";
          EnvironmentVariables = {};
        };
      };
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.primaryUser = "penny";
      users.users.penny = {
        name = "penny";
        home = "/Users/penny";
	shell = pkgs.nushell;
      };
      environment.shells = [ pkgs.nushell ]; 
      nix.settings.sandbox = true;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
      security.pam.services.sudo_local.touchIdAuth = true;
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      networking.knownNetworkServices = [
        "wifi"
      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#pennys-MacBook-Pro
    darwinConfigurations."pennys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration
	home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.penny = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
	 ];
    };
  };
}
