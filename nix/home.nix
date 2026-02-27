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
    gnupg 
    neovim
    prismlauncher
    transmission_4-qt
    mullvad
    keepassxc
    localsend
    wireshark 
    brave
    element-desktop
    nicotine-plus
    feishin
    ollama
    newsboat
<<<<<<< HEAD
    javaPackages.compiler.openjdk17-bootstrap
    jetbrains.idea-oss
=======
    signal-desktop
    temurin-jre-bin
    
>>>>>>> 981eea0bb9c838be065a5fe79c7bdc50ee0ef179

    (if pkgs.stdenv.isDarwin then iterm2 else ghostty)
    (if pkgs.stdenv.isDarwin then nvtopPackages.apple else nvtopPackages.full)


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
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dofiles/newsboat";
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
  };


  programs.ghostty= {
    enable = (if pkgs.stdenv.isDarwin then false else true);
    package = pkgs.ghostty;
    settings = {
      font-family = "Atkinson Hyperlegible Mono";
      macos-icon = "holographic";
      macos-icon-ghost-color = "#D41919";
      font-size = 20;
      theme = "Black Metal (Dark Funeral)";
    };
  };
}
