# =============================
# Zsh config migrated from Nushell
# =============================

# Aliases
alias fetch="hyfetch"
alias vim="nvim"

# Editors
export EDITOR="nvim"
export VISUAL="nvim"

# -------- Cross-platform Red Theme --------
# Terminal colors (OSC 10/11/12) and prompt styling

_set_terminal_theme_red() {
  # Foreground/Background/Cursor from your Nushell theme
  local fg="#d9e6f2"
  local bg="#09111a"
  local cursor="#d9e6f2"
  # OSC sequences: 10=foreground, 11=background, 12=cursor
  printf '\033]10;%s\007' "$fg"
  printf '\033]11;%s\007' "$bg"
  printf '\033]12;%s\007' "$cursor"
}

# Minimal cross-platform ls colors with red accents
_set_ls_colors_red() {
  case "$(uname -s)" in
    Darwin)
      export CLICOLOR=1
      # LSCOLORS pairs: di ln so pi ex bd cd su sg tw ow
      # Set directories (di) to bold red; leave others default
      export LSCOLORS="Bxxxxxxxxxxxxxxxxxxx"
      ;;
    Linux)
      # GNU LS_COLORS: set directories/executables in red-ish
      export LS_COLORS="di=31:ex=31:ln=36:so=35:pi=33:bd=31:cd=31:su=37:sg=37:tw=37:ow=37"
      ;;
  esac
}

# Prompt colors
autoload -Uz colors && colors

_git_branch() {
  command git rev-parse --abbrev-ref HEAD 2>/dev/null | sed -e 's#^HEAD$#detached#'
}

_prompt_red_theme() {
  local exit_code=$?
  local red="%F{red}"
  local grey="%F{242}"
  local reset="%f%k"
  local branch
  branch=$(_git_branch)

  local status
  if [ $exit_code -eq 0 ]; then
    status=""
  else
    status=" ${grey}[${red}${exit_code}${grey}]${reset}"
  fi

  local git_part=""
  if [ -n "$branch" ]; then
    git_part=" ${grey}on ${red}${branch}${reset}"
  fi

  PROMPT="${red}%n@%m${reset} ${grey}in${reset} ${red}%~${reset}${git_part}${status}\n${red}❯ ${reset}"
}

_init_red_theme() {
  _set_terminal_theme_red
  _set_ls_colors_red
  _prompt_red_theme
}

_init_red_theme

# -------- Nushell function `lix` translated to Zsh --------
# Usage: lix [action]
# Default action is "switch"; applies darwin-rebuild on macOS or nixos-rebuild on Linux
lix() {
  local action
  action="${1:-switch}"

  local original_dir
  original_dir="$PWD"

  cd "$HOME/dotfiles/nix" || return 1

  if command -v darwin-rebuild >/dev/null 2>&1; then
    sudo darwin-rebuild build || { cd "$original_dir"; return 1; }
    if command -v nix >/dev/null 2>&1; then
      nix store diff-closures /run/current-system ./result || true
    fi
    printf "apply above? (Y/n): "
    local resp
    read -r resp
    if [ -z "$resp" ] || [ "$resp" = "y" ] || [ "$resp" = "Y" ]; then
      sudo darwin-rebuild "$action"
      # Auto-commit any changes (e.g., flake.lock updates)
      if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        git add . && git commit -m "Auto-commit after rebuild"
      fi
      printf "System updated successfully!\n"
    else
      printf "Rebuild cancelled\n"
    fi
  elif command -v nixos-rebuild >/dev/null 2>&1; then
    sudo nixos-rebuild build --flake . || { cd "$original_dir"; return 1; }
    if command -v nix >/dev/null 2>&1; then
      nix store diff-closures /run/current-system ./result || true
    fi
    printf "apply above? (Y/n): "
    local resp
    read -r resp
    if [ -z "$resp" ] || [ "$resp" = "y" ] || [ "$resp" = "Y" ]; then
      sudo nixos-rebuild "$action" --flake .
      if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        git add . && git commit -m "Auto-commit after rebuild"
      fi
      printf "System updated successfully!\n"
    else
      printf "Rebuild cancelled\n"
    fi
  else
    printf "Neither darwin-rebuild nor nixos-rebuild found.\n" >&2
    cd "$original_dir"
    return 127
  fi

  cd "$original_dir"
}

# Ensure PATH from shells like login shells persists for interactive
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
alias cargo="cargo mommy"
alias fetch="hyfetch"
export XDG_CONFIG_HOME="$HOME/.config"
export APPLE_SSH_ADD_BEHAVIOR
exec nu
