# dotfiles/nix

Unified Nix flake for both macOS (nix-darwin) and NixOS with shared Home Manager config.

## Layout
- `flake.nix` — single flake exporting `darwinConfigurations` and `nixosConfigurations`.
- `home.nix` — shared Home Manager config/packages for all hosts.
- `hosts/common.nix` — NixOS settings shared by every NixOS host.
- `hosts/thinkpad/` — NixOS config for the ThinkPad X1 Extreme (`pennyix`).
- `hosts/framework/` — NixOS config for the Framework Laptop 16 (`framework`).
- `hosts/darwin/mac-mini.nix` — nix-darwin config for the Mac Mini (`cinders-Mac-Mini`).

## Requirements
- Nix with flakes enabled.
- macOS: nix-darwin installed.
- NixOS: standard `nixos-rebuild`.

## Usage
### macOS (nix-darwin)
```bash
# From this directory
sudo darwin-rebuild switch --flake .#cinders-Mac-Mini
# or, if you want to use the working tree (even if Git is dirty)
sudo darwin-rebuild switch --flake /Users/cinder/dotfiles/nix#cinders-Mac-Mini
```

### NixOS
```bash
sudo nixos-rebuild switch --flake .#pennyix    # ThinkPad
sudo nixos-rebuild switch --flake .#framework  # Framework 16
```

## Managing packages
- **Shared user packages**: add under `home.nix` → `home.packages`.
- **macOS-only / NixOS-only**: add in per-host HM or system packages:
  - macOS system packages: in `hosts/darwin/mac-mini.nix` under `environment.systemPackages`.
  - NixOS system packages: in `hosts/common.nix` under `environment.systemPackages` (all NixOS hosts), or in a host's `config.nix`.

## Homebrew on macOS
- Homebrew manages only the GUI apps that ship as installers (`homebrew.casks` in `hosts/darwin/mac-mini.nix`); everything else is a Nix package in `home.nix`.
- Apps nixpkgs lacks for `aarch64-darwin` but that ship as a plain `.app` in a `.dmg` are repackaged in `pkgs/mac-apps.nix`; version bumps there are manual (instructions at the top of the file).
- Before adding a cask, check nixpkgs first, then whether the app fits `pkgs/mac-apps.nix`.
- Note: Enabling Homebrew pulls in a Ruby runtime (expected).

## Troubleshooting
- **Git tree dirty or missing files in flake source**:
  - Commit changes, or use the working tree path: `--flake /Users/cinder/dotfiles/nix#host`.
- **Infinite recursion in Home Manager**:
  - Don’t self-reference `config.home.packages`. Use `lib.mkAfter`/`lib.mkBefore` to extend.
- **Conflicting binaries in Home Manager buildEnv (e.g., two `pip3`)**:
  - Ensure only one Python environment provides `pip`/`pytest` (prefer a single `python.withPackages`).
- **Show full evaluation errors**:
  ```bash
  sudo darwin-rebuild switch --flake .#cinders-Mac-Mini --show-trace
  ```

## Common commands
```bash
# Update flake inputs
nix flake update

# Format all .nix files
nix fmt

# Rebuild macOS
sudo darwin-rebuild switch --flake .#cinders-Mac-Mini

# Rebuild NixOS
sudo nixos-rebuild switch --flake .#pennyix

# Diff HM derivations
nix profile diff-closures --profile $HOME/.local/state/nix/profiles/home-manager
```

## Notes
- Keep hostnames in `flake.nix` in sync with your actual system names.
- Use Home Manager for user-level dotfiles and packages; keep system modules minimal.
