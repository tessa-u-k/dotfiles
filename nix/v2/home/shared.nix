# home/shared.nix
{ config, pkgs, userName, userEmail, ... }:

{
  # Packages that work on both platforms
  home.packages = with pkgs; [
    # Terminal & Shell
    btop
    nushell
    fastfetch
    hyfetch
    
    # Development
    git
    neovim
    rustup
    cargo-mommy
    nodejs_24
    ansible
    
    # Media
    ffmpeg
    mpv
    yt-dlp
    
    # Utilities
    p7zip
  ];

  # Git configuration (works everywhere)
  programs.git = {
    enable = true;
    userName = userName;
    userEmail = userEmail;
    
    aliases = {
      rm = ''
        !f() {
          if [ ! -d .git/removed ]; then
            mkdir -p .git/removed;
          fi;
          for file in "$@"; do
            if [ -e "$file" ]; then
              timestamp=$(date +%Y%m%d_%H%M%S);
              mv "$file" ".git/removed/''${file##*/}_''${timestamp}";
              echo "Moved $file to .git/removed/''${file##*/}_''${timestamp}";
            fi;
          done;
          git rm --cached "$@";
        }; f
      '';
    };
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core = {
        autocrlf = "input";
        editor = "nano";
      };
    };
  };

  # Shared dotfiles
  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
      recursive = true;
    };
    ".config/nushell" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nushell";
      recursive = true;
    };
  };
}
