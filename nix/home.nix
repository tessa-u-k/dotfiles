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
    hyfetch
    fastfetch
    p7zip
    btop
    gnumake
    ollama
    nixpkgs-fmt
    nixd

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
    ".config/nushell" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nushell";
      recursive = true;
    };
    ".config/zsh " = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh";
      recursive = true;
    };
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/git/.gitconfig";
    };
  };
}
