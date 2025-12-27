{ self, pkgs, lix, ... }:

{
  nix.package = pkgs.lix;

  environment.systemPackages = with pkgs; [
    neovim
    coreutils
    python313
    pkg-config
  ];


  fonts.packages = with pkgs; [
    fira-code
    open-dyslexic
    comic-mono
    nerd-fonts.comic-shanns-mono 
    atkinson-monolegible
  ];

  homebrew.enable = true;
  homebrew.onActivation.cleanup = "uninstall";
  homebrew.onActivation.upgrade = true;
  homebrew.greedyCasks = true;
  homebrew.casks = [
    "obs"
    "keepassxc"
    "zen"
    "transmission"
    "signal"
    "prismlauncher"
    "battle-net"
    "wowup"
    "splice"
    "runelite"
    "mullvad-vpn"
    "orcaslicer"
    "obsidian"
    "claude-code"
    "trezor-suite"
    "localsend"
    "microsoft-openjdk@21"
    "tor-browser"
    "jagex"
    "parallels"
    "little-snitch"
    "syncthing-app"
    "brave-browser@nightly"
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


