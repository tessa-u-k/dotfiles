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

def lix [action: string = "switch"] {
    let original_dir = $env.PWD
    cd ($env.HOME | path join "dotfiles" "nix") 
    sudo darwin-rebuild build
    nix store diff-closures /run/current-system ./result
    let response = (input "apply above? (Y/n): ")
    if $response == "y" or $response == "Y" or $response == "" {
        sudo darwin-rebuild $action
        # Commit any changes (like flake.lock updates)
        let git_status = (git status --porcelain | str trim)
        if ($git_status | is-not-empty) {
            git add .
            git commit -m "Auto-commit after rebuild"
        }
        print "System updated successfully!"
    } else {
        print "Rebuild cancelled"
    }
    
    cd $original_dir
}
