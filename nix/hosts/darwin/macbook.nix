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
    "zen"
    "battle-net"
    "wowup"
    "splice"
    "runelite"
    "orcaslicer"
    "trezor-suite"
    "tor-browser"
    "little-snitch"
    "jagex"
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

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    sandbox = "relaxed";
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}


