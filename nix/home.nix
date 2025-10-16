# home.nix
{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";
  
  home.packages = with pkgs; [
    ghostty-bin
    mpv
    yt-dlp
    ffmpeg
    cargo-mommy
    rustup
    manga-tui
    hyfetch
    fastfetch
    p7zip
    ansible
    btop
    nushell
    nodejs_24
];


  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
    ".config/nushell".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nushell";
  };
  
  programs.home-manager.enable = true;
}
