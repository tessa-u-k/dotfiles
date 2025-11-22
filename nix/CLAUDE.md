# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a unified Nix flake managing two systems from a single configuration:
- **macOS (MacBook Pro)**: aarch64-darwin using nix-darwin
- **NixOS (ThinkPad)**: x86_64-linux

Key architectural pattern: **System/User Configuration Split**
- System configuration in host-specific files (`hosts/darwin/macbook.nix`, `hosts/thinkpad/config.nix`)
- User packages and dotfiles in shared `home.nix` via Home Manager
- External dotfiles linked via `mkOutOfStoreSymlink` to `~/dotfiles/` (nvim, zsh, git configs)

Uses Lix (Nix fork) instead of standard Nix, with all inputs tracking nixos-unstable.

## Build and Deployment Commands

### Rebuild macOS
```bash
lix switch --flake .#pennys-MacBook-Pro
# or with dirty git tree:
lix switch --flake /Users/penny/dotfiles/nix#pennys-MacBook-Pro
```

### Rebuild NixOS
```bash
sudo nixos-rebuild switch --flake .#pennyix
```

### Update Dependencies
```bash
nix flake update  # Updates flake.lock with latest versions
```

### Debugging
```bash
# Show full evaluation traces for errors
lix switch --flake .#pennys-MacBook-Pro --show-trace

# Compare Home Manager profile changes
nix profile diff-closures --profile $HOME/.local/state/nix/profiles/home-manager
```

## Configuration Structure

### Entry Points
- `flake.nix`: Root configuration defining both `darwinConfigurations."pennys-MacBook-Pro"` and `nixosConfigurations.pennyix`
- Both configurations import the same `home.nix` for user-level packages

### Adding Packages

**Shared user packages** (available on both systems):
- Add to `home.nix` → `home.packages`

**Platform-specific packages**:
- macOS system packages: `hosts/darwin/macbook.nix` → `environment.systemPackages`
- NixOS system packages: `hosts/thinkpad/config.nix` → `environment.systemPackages`

**Platform conditionals** in `home.nix`:
```nix
(if pkgs.stdenv.isDarwin then package-darwin else package-linux)
```

### Dotfiles Management
Dotfiles are NOT stored in this repo. This repo only manages symlinks via Home Manager:
- Neovim config: `~/dotfiles/nvim`
- Zsh config: `~/dotfiles/zsh/`
- Git config: `~/dotfiles/git/`

Changes to dotfiles should be made in the external `~/dotfiles/` directory.

## macOS-Specific Notes

### Homebrew
Homebrew is enabled for GUI applications (casks). The configuration auto-cleans and auto-upgrades casks on each rebuild.

Current casks include: OBS, browsers (Chrome, Zen), messaging (Signal, Vesktop), gaming (PrismLauncher, Battle.net, WoWup, RuneLite, Steam), development tools (Cursor, Claude Code, Docker Desktop), security (KeePassXC, Mullvad VPN, Trezor Suite), and utilities (Transmission, OrcaSlicer, Obsidian).

### Services
macOS uses launchd agents:
- `ollama`: ML inference service (runs as user agent)
- `trezord`: Hardware wallet daemon
- `tailscale`: VPN/mesh networking

## NixOS-Specific Notes

### Desktop Environment
- Window manager: Hyprland (Wayland compositor) with UWSM
- Audio: PipeWire (replaces PulseAudio and ALSA)
- Terminal: Kitty

### Encryption
LUKS encryption is configured at boot. Hardware configuration is auto-generated in `hosts/thinkpad/hardwareconfig.nix`.

### Services
- Syncthing for file synchronization
- NetworkManager for networking
- Tailscale for VPN

## Common Issues

### Infinite recursion in Home Manager
Don't self-reference `config.home.packages`. Use `lib.mkAfter` or `lib.mkBefore` to extend package lists.

### Conflicting binaries (e.g., multiple pip3)
Ensure only one Python environment provides system tools. Use `python.withPackages` instead of installing packages separately.

### Git tree dirty errors
Commit changes before rebuilding, or use the full path: `--flake /Users/penny/dotfiles/nix#host`

## Flake Inputs
- `nixpkgs`: nixos-unstable (latest packages)
- `lix` + `lix-module`: Lix package manager (Nix fork)
- `home-manager`: User environment management
- `darwin`: macOS system configuration framework

All inputs follow the same nixpkgs version for consistency.
