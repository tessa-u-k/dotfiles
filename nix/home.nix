{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    manga-tui
    wget
    curl
    p7zip
    ansible
    nodejs_24
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
    p7zip
    btop
    gnumake
    nixpkgs-fmt
    nixd
    zig
    sequoia-sq 
    neovim
    claude-code
    prismlauncher
    transmission_4-qt
    mullvad
    signal-desktop-bin
    keepassxc
    localsend
    wireshark 
    jdk25_headless
    brave
    element-desktop
    nicotine-plus
    vesktop
    obsidian
    feishin
    syncthing
    ollama

    (if pkgs.stdenv.isDarwin then ghostty-bin else ghostty)

    # Python with packages
    (python313.withPackages (ps: with ps; [
      pip
      mcp
      requests
      ultralytics
    ]))
  ];


  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
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
