{ self, pkgs, ... }:

{  
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
    "docker-desktop"
    "claude-code"
    "trezor-suite"
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
      EnvironmentVariables = { };
    };
  };

  system.primaryUser = "penny";
  users.users.penny = {
    name = "penny";
    home = "/Users/penny";
    shell = pkgs.zsh;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  networking.knownNetworkServices = [ "wifi" ];

  nix.settings.sandbox = true;
  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}


