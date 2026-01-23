local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = "0.1.4",
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Rose Pine colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })()
    end,
  },

  -- Nvim Tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Web devicons
  'nvim-tree/nvim-web-devicons',

  -- Toggleterm
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = true
  },

  -- Tmux Navigator
  {
    'christoomey/vim-tmux-navigator',
    lazy = false
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons'
  },

  -- LSP
  'neovim/nvim-lspconfig',

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },

  -- Dressing (better UI for inputs)
  'stevearc/dressing.nvim',

  -- AI Assistant (Cursor-like chat window)
  {
    'olimorris/codecompanion.nvim',
    version = "17.33.0",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
      'stevearc/dressing.nvim',
    },
  },
  -- lualine 
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  }
}
