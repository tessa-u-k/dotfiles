{ self, pkgs, ... }:

{  
  environment.systemPackages = with pkgs; [
    neovim
    coreutils
    python313
    pkg-config
  ];


  fonts.packages = with pkgs; [
    fira-code
  ];

  homebrew.enable = true;
  homebrew.onActivation.cleanup = "uninstall";
  homebrew.onActivation.upgrade = true;
  homebrew.greedyCasks = true;
  homebrew.casks = [ 
    "obs"
    "google-chrome"    
    "keepassxc"
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
    "runelite"
    "steam"
    "mullvad-vpn"
    "orcaslicer"
    "obsidian"
    "cursor"
    "docker-desktop"
    "claude-code"
    "trezor-suite"
    "onionshare"
    "transmission"
    "microsoft-openjdk@21"
    "tor-browser"
    "imaging-edge"
    "utm"
    "jagex"
    "little-snitch"
  ];
  
  homebrew.brews = [
    {
      name = "ollama";
      start_service = true;
    }
  ];


  services.trezord.enable = true;
  services.tailscale.enable = true;
  services.tailscale.overrideLocalDns = true;
  system.primaryUser = "penny";
  users.users.penny = {
    name = "penny";
    home = "/Users/penny";
    shell = pkgs.zsh;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  networking.knownNetworkServices = [ "wifi" ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    sandbox = "relaxed";
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}


