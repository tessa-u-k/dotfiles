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
    tag = "0.1.8",
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Rose Pine colorscheme (fallback: `:lua ColorMyPencils("rose-pine")`;
  -- the default is colors/evangelion.lua, set in after/plugin/colors.lua)
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    -- `main` is the maintained rewrite (the frozen `master` branch breaks on
    -- Neovim 0.12). It does not support lazy-loading; parsers are compiled
    -- with the `tree-sitter` CLI (see nix/home.nix).
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
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
  },

  -- Popup showing the available keybinds after a prefix (e.g. <leader>)
  'folke/which-key.nvim',

  -- Git signs in the gutter, hunk staging/preview/blame
  'lewis6991/gitsigns.nvim',

  -- Add/change/delete surrounding quotes, brackets and tags
  { 'kylechui/nvim-surround', version = "*" },

  -- Auto-close brackets and quotes
  'windwp/nvim-autopairs',

  -- Indent guides
  { 'lukas-reineke/indent-blankline.nvim', main = "ibl" },

  -- Highlight and search TODO/FIXME/NOTE comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Diagnostics / quickfix / references list
  'folke/trouble.nvim',

  -- Visual undo history (pairs with the persistent undofile in init.lua)
  'mbbill/undotree',
}
)
