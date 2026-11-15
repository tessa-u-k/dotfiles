{
  config,
  lib,
  pkgs,
  meshterm, # flake input, passed in through extraSpecialArgs in flake.nix
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  # Vendor .dmg releases repackaged for macOS; see pkgs/mac-apps.nix.
  macApps = pkgs.callPackage ./pkgs/mac-apps.nix { };
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
      (callPackage ./pkgs/claude-mommy.nix { }) # the same, for Claude Code's Bash tool
      rustup
      hyfetch
      fastfetch
      btop
      gnumake
      gnupg
      # ykman: manage the YubiKey's OpenPGP applet (touch policy, PINs, reset).
      yubikey-manager
      neovim
      prismlauncher
      qbittorrent
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
      meshterm.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Python with packages
      (python313.withPackages (
        ps: with ps; [
          pip
        ]
      ))
    ]
    # On NixOS these come from system modules (programs.ghostty below,
    # programs.wireshark and services.mullvad-vpn in hosts/thinkpad/config.nix).
    # keepassxc too: its polkit policy is only seen in the system profile.
    ++ lib.optionals isDarwin [
      keepassxc
      iterm2
      nvtopPackages.apple
      wireshark
      mullvad
      discord # unfree: allowed by name in hosts/darwin/mac-mini.nix
      transmission_4-mac # the native Transmission.app
      macApps.obs-studio
      macApps.zen-browser
      macApps.orca-slicer
      macApps.tor-browser
      macApps.trezor-suite # unfree: allowed by name in hosts/darwin/mac-mini.nix
    ]
    ++ lib.optionals isLinux [
      nvtopPackages.full
      # wl-copy/wl-paste: what terminal programs (Claude Code, neovim's "+
      # register) use to reach the Wayland clipboard.
      wl-clipboard
    ];

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
    };
    ".newsboat" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/newsboat";
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
    ".ssh/config" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ssh/config";
    };
    # Make gpg's scdaemon reach the YubiKey through PC/SC (pcscd) instead of
    # its own USB driver; the two fight over the device otherwise, and ykman
    # needs pcscd.
    ".gnupg/scdaemon.conf".text = ''
      disable-ccid
    '';

  };

  services.syncthing = {
    enable = true;
  };

  programs.ghostty = {
    enable = isLinux;
    package = pkgs.ghostty;
    settings = {
      font-family = "Atkinson Hyperlegible Mono";
      font-size = 20;
      theme = "Black Metal (Dark Funeral)";
    };
  };
}
