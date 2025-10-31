{ config, pkgs, ... }:
{
  imports = [ ../home.nix ];

  # Re-add mac-specific user packages from the previous mac/home.nix
  home.packages = (config.home.packages or []) ++ (with pkgs; [
    ghostty-bin
    git
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
    python313Packages.pip
    python313Packages.pytest_7
    python313Packages.setuptools
    gnumake
  ]);
}


