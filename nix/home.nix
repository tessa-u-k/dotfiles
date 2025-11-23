{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
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
    gnupg
    neovim
    (if pkgs.stdenv.isDarwin then iterm2 else ghostty)

    # Python with packages
    (python313.withPackages (ps: with ps; [
      pip
      pytest
      mcp
      requests
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

  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      shell-integration = "zsh";
      font-family = "ComicShannsMono Nerd Font";
      font-family-bold = "ComicShannsMono Nerd Font";
      font-family-italic = "ComicShannsMono Nerd Font";
      font-family-bold-italic = "ComicShannsMono Nerd Font";
      macos-icon = "holographic";
      macos-icon-ghost-color = "#D41919";
      font-size = 24;
      theme = "Black Metal (Dark Funeral)";
    };
  };
}
