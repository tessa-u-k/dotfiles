# Vendor .dmg releases repackaged for macOS: the .app is copied out of the
# vendor's disk image into $out/Applications, untouched (so its code signature
# stays valid). home.nix installs these on the Mac.
#
# To update one: bump `version` (and `url` if its shape changed) and replace
# `sha256` with the new image's hash, e.g. from
#   nix store prefetch-file --hash-type sha256 <url>
# or from the matching Homebrew cask (`brew info --cask --json=v2 <cask>`).
{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

let
  mkDmgApp =
    {
      pname,
      version,
      url,
      sha256,
      appName, # the bundle inside the image, e.g. "OBS.app"
      meta ? { },
    }:
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = fetchurl { inherit url sha256; };

      nativeBuildInputs = [ _7zz ];

      # 7zz reads both HFS+ and APFS images. -snld keeps the symlinks inside
      # the bundle (frameworks are full of them). It exits non-zero on things
      # that do not matter here, such as the image's /Applications shortcut,
      # so the check is whether the bundle came out.
      unpackPhase = ''
        runHook preUnpack
        7zz x -snld -y "$src" >/dev/null || true
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        app=$(find . -maxdepth 3 -type d -name ${lib.escapeShellArg appName} -print -quit)
        if [ -z "$app" ]; then
          echo "${appName} not found in the disk image" >&2
          exit 1
        fi
        mkdir -p "$out/Applications"
        cp -R "$app" "$out/Applications/"
        runHook postInstall
      '';

      # Leave the bundle exactly as shipped: patching or stripping would break
      # its signature.
      dontConfigure = true;
      dontBuild = true;
      dontFixup = true;

      meta = {
        platforms = lib.platforms.darwin;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      }
      // meta;
    };
in
{
  obs-studio = mkDmgApp rec {
    pname = "obs-studio";
    version = "33.0.1";
    url = "https://cdn-fastly.obsproject.com/downloads/obs-studio-${version}-macos-apple.dmg";
    sha256 = "3d6b2eedeb56416602af635adaba32327fdf11ff9d2806a4ce7d5b608de73238";
    appName = "OBS.app";
    meta = {
      description = "Video recording and live streaming";
      homepage = "https://obsproject.com/";
      license = lib.licenses.gpl2Plus;
      platforms = [ "aarch64-darwin" ];
    };
  };

  zen-browser = mkDmgApp rec {
    pname = "zen-browser";
    version = "1.24.2b";
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.macos-universal.dmg";
    sha256 = "04ee33c2e906b52f90f73384aa50e80a92530ae4b3414fb26a0a982e257f172c";
    appName = "Zen.app";
    meta = {
      description = "Firefox-based web browser";
      homepage = "https://zen-browser.app/";
      license = lib.licenses.mpl20;
    };
  };

  orca-slicer = mkDmgApp rec {
    pname = "orca-slicer";
    version = "2.5.1";
    url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v${version}/OrcaSlicer_Mac_universal_V${version}.dmg";
    sha256 = "ddf48a7f34785a4d5b4313e4dc4d7ad01769d48bc4c8d825f809da96593e6f46";
    appName = "OrcaSlicer.app";
    meta = {
      description = "G-code generator for 3D printers";
      homepage = "https://github.com/OrcaSlicer/OrcaSlicer";
      license = lib.licenses.agpl3Only;
    };
  };

  tor-browser = mkDmgApp rec {
    pname = "tor-browser";
    version = "16.0.1";
    url = "https://www.torproject.org/dist/torbrowser/${version}/tor-browser-macos-${version}.dmg";
    sha256 = "f7c1f995969e6588a770d2096591ac397cd2cbb8a85b8c0c30ec206290ec2b90";
    appName = "Tor Browser.app";
    meta = {
      description = "Web browser that routes traffic through the Tor network";
      homepage = "https://www.torproject.org/";
      license = lib.licenses.mpl20;
    };
  };

  # Unfree: allowed by name in hosts/darwin/mac-mini.nix.
  trezor-suite = mkDmgApp rec {
    pname = "trezor-suite";
    version = "26.10.3";
    url = "https://data.trezor.io/suite/releases/desktop/latest/Trezor-Suite-${version}-mac-arm64.dmg";
    sha256 = "d1e1bc3b597a800d4395ac152ee5445a8eadcb4c318e831a3227bbd49694d9a3";
    appName = "Trezor Suite.app";
    meta = {
      description = "Desktop app for Trezor hardware wallets";
      homepage = "https://suite.trezor.io/";
      license = lib.licenses.unfree;
      platforms = [ "aarch64-darwin" ];
    };
  };
}
