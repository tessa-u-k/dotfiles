# home.nix
{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";
  
  home.packages = with pkgs; [
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
  ];

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

  programs.git = {
    enable = true;
    userName = "angel";
    userEmail = "angel@klbr.mom";
    
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
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = false;
      };
      push = {
        autoSetupRemote = true;
      };
      core = {
        autocrlf = "input";
        editor = "nano";
      };
    };
  };
}
