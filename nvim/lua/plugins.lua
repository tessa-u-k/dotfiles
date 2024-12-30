--- This file can be loaded by calling `lua require('plugins')` from your init.vim
  -- Simple plugins can be specified as strings

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { 'nvim-telescope/telescope.nvim', tag="0.1.4",
	requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({ "rose-pine/neovim", as = "rose-pine",
	config = function()
		vim.cmd('colorscheme rose-pine')
	end
    })

    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    use { 'nvim-tree/nvim-tree.lua',
         requires = { 'nvim-tree/nvim-web-devicons',},
    }
    use 'nvim-tree/nvim-web-devicons' 

    use 'voldikss/vim-floaterm'

    use { 'christoomey/vim-tmux-navigator', lazy = false }

    use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

    use({'neovim/nvim-lspconfig'})
    use({'hrsh7th/nvim-cmp'})
    use({'hrsh7th/cmp-nvim-lsp'})

    use({'huggingface/llm.nvim'})

end)
