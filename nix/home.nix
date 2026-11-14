{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in

{
  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
  programs.home-manager.enable = true;

  home.packages =
    with pkgs;
    [
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
      qbittorrent
      keepassxc
      localsend
      element-desktop
      feishin
      newsboat
      temurin-jre-bin
      dolphin-emu
      sdrpp
      gnuradio
      vscodium
      ansible
      esphome
      thunderbird

      # Python with packages
      (python313.withPackages (
        ps: with ps; [
          pip
        ]
      ))
    ]
    # On NixOS these come from system modules (programs.ghostty below,
    # programs.wireshark and services.mullvad-vpn in hosts/thinkpad/config.nix).
    ++ lib.optionals isDarwin [
      iterm2
      nvtopPackages.apple
      wireshark
      mullvad
    ]
    ++ lib.optionals isLinux [
      nvtopPackages.full
    ];

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
      recursive = true;
    };
    ".newsboat" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/newsboat";
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

  services.syncthing = {
    enable = true;
  };

  programs.ghostty = {
    enable = isLinux;
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
