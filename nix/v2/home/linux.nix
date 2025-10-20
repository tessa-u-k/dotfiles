# home/linux.nix
{ config, pkgs, userName, userEmail, ... }:

{
  imports = [ ./shared.nix ];
  
  home.stateVersion = "25.05";
  
  # Linux-specific packages
  home.packages = with pkgs; [
    ghostty # Terminal (if available on Linux)
    manga-tui
    python313Packages.pip
    python313Packages.pytest_7
  ];
}
