{
  self,
  lib,
  pkgs,
  ...
}:
{

  nix.package = pkgs.lixPackageSets.lix_2_96.lix; # stable (2.95) fails: nixpkgs passes -Dmimalloc, which 2.95 lacks

  # pyqt6 6.11 on darwin: QtCore fails to import with "symbol not found
  # __ZN13QPyTableRange16staticMetaObjectE". The range-model classes are behind
  # `#if QT_VERSION >= 0x060a00`, which moc seems to evaluate as false here, so
  # it never emits their meta-objects. Our Qt is >= 6.10, so drop the guard.
  # Needed for gnuradio's GUI (via pyqtgraph).
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pyfinal: pyprev: {
          pyqt6 = pyprev.pyqt6.overridePythonAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace qpy/QtCore/qpycore_qrangemodel.h qpy/QtCore/qpycore_qrangemodel.cpp \
                --replace-fail '#if QT_VERSION >= 0x060a00' '#if 1'
            '';
          });
        })
      ];
    })
  ];
  environment.systemPackages = with pkgs; [
    neovim
    coreutils
    pkg-config
  ];

  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.comic-shanns-mono
    atkinson-monolegible
  ];

  # Homebrew only for the apps that can't be nix packages: they ship as
  # installers rather than a plain .app. Everything else comes from nixpkgs or
  # from pkgs/mac-apps.nix (see home.nix).
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "uninstall";
  homebrew.onActivation.upgrade = true;
  homebrew.greedyCasks = true;
  homebrew.casks = [
    # Not greedy: Battle.net updates itself, and its cask is a manual
    # installer that brew cannot upgrade. A greedy upgrade fails, which fails
    # `brew bundle` and stops activation before home-manager runs.
    {
      name = "battle-net";
      greedy = false;
    }
    "wowup"
    "splice"
  ];

  system.primaryUser = "cinder";
  users.users.penny = {
    name = "cinder";
    home = "/Users/cinder";
    shell = pkgs.zsh;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Thunderbird's external-GnuPG support (needed for the YubiKey) dlopens
  # libgpgme.dylib, but only searches its own app folder, /usr/local/lib,
  # /opt/local/lib and /opt/homebrew/lib -- never the Nix profile.
  system.activationScripts.postActivation.text = ''
    mkdir -p /usr/local/lib
    ln -sfn ${pkgs.gpgme}/lib/libgpgme.dylib /usr/local/lib/libgpgme.dylib
  '';

  # Unfree packages stay blocked, except the ones named here.
  nixpkgs.config.allowUnfree = false;
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "trezor-suite"
    ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    sandbox = false;
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}
