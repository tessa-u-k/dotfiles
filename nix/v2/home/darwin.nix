# home/darwin.nix
{ config, pkgs, userName, userEmail, ... }:

{
  imports = [ ./shared.nix ];
  
  home.stateVersion = "25.05"; # Adjust as needed
  
  # macOS-specific packages
  home.packages = with pkgs; [
    # Add any macOS-specific tools here
  ];
  
  # macOS-specific configurations can go here
}
