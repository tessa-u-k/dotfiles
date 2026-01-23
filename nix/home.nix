{ config, pkgs, lix, ... }:

{
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    manga-tui
    wget
    curl
    p7zip
    tree-sitter
    zstd
    gcc
    git
    mpv
    yt-dlp
    ffmpeg
    cargo-mommy
    rustup
    hyfetch
    fastfetch
    btop
    gnumake
    sequoia-sq 
    neovim
<<<<<<< Updated upstream
    prismlauncher
    transmission_4-qt
    mullvad
    keepassxc
    localsend
    wireshark 
    brave
    element-desktop
    nicotine-plus
    vesktop
    feishin
    ollama
    newsboat

    (if pkgs.stdenv.isDarwin then ghostty-bin else ghostty)
    (if pkgs.stdenv.isDarwin then nvtopPackages.apple else nvtopPackages.full)
=======
    localsend
    (if pkgs.stdenv.isDarwin then iterm2 else ghostty)
>>>>>>> Stashed changes

    # Python with packages
    (python313.withPackages (ps: with ps; [
      pip
    ]))
  ];


  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
      recursive = true;
    };
    ".newsboat" = {
      source = config.lib.file.mkOutOfStoreSymLink "${config.home.homeDirectory}/dofiles/newsboat";
      recursive = true;
    };
    ".zshrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";
    };
    ".zshenv" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zshenv";
    };
    ".zprofile" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zprofile";
    };
    ".aliasrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.aliasrc";
    };
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/git/.gitconfig";
    };
    ".news" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/newsboat/.gitconfig";
    };

  };



  services.syncthing = {
    enable = true;
    
    # Optional: Customize the data directory
    # tray.enable = true;  # Enable system tray icon (if using a GUI)
  };


  programs.ghostty= {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      font-family = "Atkinson Hyperlegible Mono";
      macos-icon = "holographic";
      macos-icon-ghost-color = "#D41919";
      font-size = 20;
      theme = "Black Metal (Dark Funeral)";
    };
  };
}
