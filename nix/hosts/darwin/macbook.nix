{ self, pkgs, ... }:
{
  # Use Lix from nixpkgs (recommended for stable)
  nix.package = pkgs.lixPackageSets.stable.lix;

  environment.systemPackages = with pkgs; [
    neovim
    coreutils
    python313
    pkg-config
  ];

  homebrew.enable = true;
  homebrew.onActivation.cleanup = "uninstall";
  homebrew.onActivation.upgrade = true;
  homebrew.casks = [
    "obs"
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
    "mullvad-vpn"
    "orcaslicer"
    "obsidian"
    "element"
    "cursor"
  ];

  services.trezord.enable = true;
  services.tailscale.enable = true;
  services.tailscale.overrideLocalDns = true;

  # Ollama user service
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

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.primaryUser = "penny";
  users.users.penny = {
    name = "penny";
    home = "/Users/penny";
    shell = pkgs.nushell;
  };
  environment.shells = [ pkgs.nushell ];
  nix.settings.sandbox = true;

  system.stateVersion = 6;
  security.pam.services.sudo_local.touchIdAuth = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.knownNetworkServices = [ "wifi" ];
}


