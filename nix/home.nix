{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    manga-tui
    wget
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
    ollama
    nixpkgs-fmt
    nixd
    (if pkgs.stdenv.isDarwin then ghostty-bin else ghostty)

    # Python with packages
    (python313.withPackages (ps: with ps; [
      pip
      pytest
    ]))
  ];

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
    ];
  };

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
}
