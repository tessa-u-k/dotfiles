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

  # The words mommy uses, for cargo-mommy and claude-mommy alike. Each is a
  # slash-separated list ("girl/pup"); one entry is picked at random per
  # message. A CARGO_MOMMYS_* variable set in the shell still overrides these.
  mommy = {
    little = "cow"; # what mommy calls you
    pronouns = "her"; # mommy's pronoun, possessive: "her little girl"
    roles = "mommy"; # who mommy is
    emotes = "❤️/💖/💗/💓/💞"; # what ends each message
    # Your own pronoun, subject form (she/he/they/it): "it's such a good cow".
    # claude-mommy only; cargo-mommy has no setting for it.
    littlePronouns = "it";
  };

  # cargo-mommy for Claude Code: a hook command and an output style; see
  # pkgs/claude-mommy.nix.
  claudeMommy = pkgs.callPackage ./pkgs/claude-mommy.nix mommy;

  # cargo-mommy with the same words as its defaults.
  cargoMommy = pkgs.symlinkJoin {
    name = "cargo-mommy";
    paths = [ pkgs.cargo-mommy ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/cargo-mommy \
        --set-default CARGO_MOMMYS_LITTLE ${lib.escapeShellArg mommy.little} \
        --set-default CARGO_MOMMYS_PRONOUNS ${lib.escapeShellArg mommy.pronouns} \
        --set-default CARGO_MOMMYS_ROLES ${lib.escapeShellArg mommy.roles} \
        --set-default CARGO_MOMMYS_EMOTES ${lib.escapeShellArg mommy.emotes}
    '';
  };
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
      cargoMommy
      claudeMommy # the same, for Claude Code
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
    # The output style that makes Claude Code talk as mommy. It is switched on
    # by "outputStyle": "Mommy" in ~/.claude/settings.json, which Nix does not
    # manage. force: replace the hand-written copy this one took over from.
    ".claude/output-styles/mommy.md" = {
      source = "${claudeMommy}/share/claude-mommy/output-styles/mommy.md";
      force = true;
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
      font-size = 20;
      theme = "Black Metal (Dark Funeral)";
    };
  };
}
