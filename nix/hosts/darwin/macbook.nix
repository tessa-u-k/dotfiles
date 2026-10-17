{ self, pkgs, lix, ... }:
{

  nix.package = pkgs.lixPackageSets.lix_2_96.lix; # stable (2.95) fails: nixpkgs passes -Dmimalloc, which 2.95 lacks
  environment.systemPackages = with pkgs; [
    neovim
    coreutils
    pkg-config
  ];


  fonts.packages = with pkgs; [
    fira-code
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
    "orcaslicer"
    "trezor-suite"
    "transmission"
    "tor-browser"
    "little-snitch"
    "discord"
  ];
  
  system.primaryUser = "cinder";
  users.users.penny = {
    name = "cinder";
    home = "/Users/cinder";
    shell = pkgs.zsh;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  nixpkgs.config.allowUnfree = false;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    sandbox = true;        
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}


