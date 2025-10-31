# dotfiles/nix

Unified Nix flake for both macOS (nix-darwin) and NixOS with shared Home Manager config.

## Layout
- `flake.nix` — single flake exporting `darwinConfigurations` and `nixosConfigurations`.
- `home.nix` — shared Home Manager config/packages for all hosts.
- `hosts/` — host-specific NixOS or darwin modules (optional).

## Requirements
- Nix with flakes enabled.
- macOS: nix-darwin installed.
- NixOS: standard `nixos-rebuild`.

## Usage
### macOS (nix-darwin)
```bash
# From this directory
lix switch --flake .#pennys-MacBook-Pro
# or, if you want to use the working tree (even if Git is dirty)
lix switch --flake /Users/penny/dotfiles/nix#pennys-MacBook-Pro
```

### NixOS
```bash
sudo nixos-rebuild switch --flake .#pennyix
```

## Managing packages
- **Shared user packages**: add under `home.nix` → `home.packages`.
- **macOS-only / NixOS-only**: add in per-host HM or system packages:
  - macOS system packages: in `flake.nix` under `environment.systemPackages` inside the darwin module list.
  - NixOS system packages: in `nixos/config.nix` under `environment.systemPackages`.

## Homebrew on macOS
- Homebrew is enabled to manage GUI apps (`homebrew.casks`).
- To go pure-Nix, set `homebrew.enable = false;` in `flake.nix` and replace casks with Nix packages where possible.
- Note: Enabling Homebrew pulls in a Ruby runtime (expected).

## Troubleshooting
- **Git tree dirty or missing files in flake source**:
  - Commit changes, or use the working tree path: `--flake /Users/penny/dotfiles/nix#host`.
- **Infinite recursion in Home Manager**:
  - Don’t self-reference `config.home.packages`. Use `lib.mkAfter`/`lib.mkBefore` to extend.
- **Conflicting binaries in Home Manager buildEnv (e.g., two `pip3`)**:
  - Ensure only one Python environment provides `pip`/`pytest` (prefer a single `python.withPackages`).
- **Show full evaluation errors**:
  ```bash
  lix switch --flake .#pennys-MacBook-Pro --show-trace
  ```

## Common commands
```bash
# Update flake inputs
nix flake update

# Rebuild macOS
tlix switch --flake .#pennys-MacBook-Pro

# Rebuild NixOS
sudo nixos-rebuild switch --flake .#pennyix

# Diff HM derivations
nix profile diff-closures --profile $HOME/.local/state/nix/profiles/home-manager
```

## Notes
- Keep hostnames in `flake.nix` in sync with your actual system names.
- Use Home Manager for user-level dotfiles and packages; keep system modules minimal.
