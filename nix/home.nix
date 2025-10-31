{ config, pkgs, ... }:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    manga-tui
    p7zip
    ansible
    nodejs_24
    tree-sitter
    zstd
    gcc
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
    gnumake
    ollama
    
    # Python with packages
    (python313.withPackages (ps: with ps; [
      pip
      pytest
    ]))
  ];
  # Add Doom Emacs to PATH
  home.sessionPath = [
    "$HOME/.config/emacs/bin"
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
    ".zshrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";
    };
  };

  programs.git = {
    enable = true;
    settings.user.name = "angel";
    settings.user.email = "angel@klbr.mom";
    
    settings.aliases = {
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
    
    settings = {
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

  # Neovim with packer plugin
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
    ];
  };
}
