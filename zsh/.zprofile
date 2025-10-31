# Login shell setup: PATH, Homebrew, GNU utils, and color settings

# Homebrew (macOS)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Prefer GNU coreutils/findutils/sed/tar/grep/gawk if installed via Homebrew (macOS)
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"

# Cross-platform red theme: set terminal and ls colors at login
_set_terminal_theme_red() {
  local fg="#d9e6f2"
  local bg="#09111a"
  local cursor="#d9e6f2"
  printf '\033]10;%s\007' "$fg"
  printf '\033]11;%s\007' "$bg"
  printf '\033]12;%s\007' "$cursor"
}

_set_ls_colors_red() {
  case "$(uname -s)" in
    Darwin)
      export CLICOLOR=1
      export LSCOLORS="Bxxxxxxxxxxxxxxxxxxx"
      ;;
    Linux)
      export LS_COLORS="di=31:ex=31:ln=36:so=35:pi=33:bd=31:cd=31:su=37:sg=37:tw=37:ow=37"
      ;;
  esac
}

_set_terminal_theme_red
_set_ls_colors_red


