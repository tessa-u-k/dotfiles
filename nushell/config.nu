# config.nu
#
# Installed by:
# version = "0.107.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
source ~/.config/nushell/azu.nu
alias fetch = hyfetch
alias vim = nvim
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false 


def lixbuild [action: string = "switch"] {
    # Save current directory and change to dotfiles/nix
    let original_dir = $env.PWD
    cd ($env.HOME | path join "dotfiles" "nix")
    
    # Check if there are uncommitted changes
    let git_status = (git status --porcelain | str trim)
    
    if ($git_status | is-not-empty) {
        print "Found uncommitted changes. Committing..."
        git add .
        git commit -m "Auto-commit before rebuild"
    }
    
    # Build the new system
    sudo darwin-rebuild build

    # Show the diff between current and new system
    nix store diff-closures /run/current-system ./result

    # Ask for confirmation
    let response = (input "Apply these changes? (y/n): ")

    if $response == "y" {
        sudo darwin-rebuild $action
    } else {
        print "Rebuild cancelled"
    }
    
    # Return to original directory
    cd $original_dir
}
