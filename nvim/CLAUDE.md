# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using lazy.nvim as the plugin manager. The configuration is structured following Neovim's standard directory layout with a focus on LSP support, modern UI components, and AI-assisted coding via CodeCompanion.

## Architecture

### Configuration Structure

- `init.lua` - Main entry point that:
  - Loads core configuration modules (`tess/remap`, `tess/set`, `plugins`)
  - Configures buffer lifecycle autocmds for auto-closing when only special buffers remain
  - Sets up persistent undo directory
  - Disables netrw in favor of nvim-tree

- `lua/tess/` - Core configuration modules:
  - `set.lua` - Editor settings (indentation, line numbers, scrolloff, etc.)
  - `remap.lua` - Global keymaps and leader key configuration

- `lua/plugins.lua` - Plugin specifications using lazy.nvim

- `after/plugin/` - Plugin-specific configurations that load after plugins are installed:
  - `lsp.lua` - LSP setup using new Neovim 0.11+ `vim.lsp.config` API
  - `codecompanion.lua` - AI assistant configuration
  - `treesitter.lua` - Syntax highlighting and parsing
  - `cmp.lua` - Autocompletion
  - `telescope.lua` - Fuzzy finder
  - Other UI plugin configs (nvimtree, lualine, bufferline, toggleterm, colors)

### LSP Configuration

This config uses the **new Neovim 0.11+ LSP API** (`vim.lsp.config` and `vim.lsp.enable`), not the older `lspconfig.setup()` pattern. Currently configured language servers:
- Gleam (`gleam lsp`)
- Rust Analyzer (`rust-analyzer`)

When adding new LSP servers, use the pattern in `after/plugin/lsp.lua`:
```lua
vim.lsp.config('language_server_name', {
  cmd = {'command'},
  root_markers = {'marker_file'},
  capabilities = lspconfig_defaults.capabilities,
})
vim.lsp.enable('language_server_name')
```

### AI Integration

CodeCompanion is configured to use Ollama with the `gpt-oss:20b` model. The chat window opens as a vertical split on the right side (40% width). Toggle with `<leader>a` in normal or visual mode.

### Special Behaviors

**Auto-quit Logic**: The config implements custom autocmds that automatically close Neovim when only special buffers (NvimTree, toggleterm, CodeCompanion) remain open. This logic is in `init.lua` with the `only_special_buffers_open()` function.

**Modified `:q!` behavior**: `:q!` and `:Q` are aliased to `qall!` to close all windows at once.

### Key Mappings

Leader key: `<Space>`

Essential keybinds:
- `<leader>t` - Toggle NvimTree
- `<leader>ft` - Toggle terminal
- `<leader>l/h` - Cycle through buffers (next/prev)
- `<leader>L/H` - Move current buffer (next/prev)
- `<leader>a` - Toggle CodeCompanion chat

LSP keybinds (when LSP attached):
- `K` - Hover documentation
- `gd` - Go to definition
- `gr` - Go to references
- `F2` - Rename symbol
- `F3` - Format code
- `F4` - Code action

## Plugin Management

Install/update plugins: `:Lazy`

Lazy.nvim auto-installs on first run. Treesitter parsers are manually specified in `after/plugin/treesitter.lua` (not auto-installed).

## Theme

Uses rose-pine colorscheme with 24-bit color support enabled.
