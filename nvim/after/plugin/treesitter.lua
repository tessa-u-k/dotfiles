-- Set parser install directory to use lazy.nvim location
local parser_install_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
vim.opt.runtimepath:append(parser_install_dir)

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed = { "rust", "javascript", "typescript", "cpp", "c", "lua", "vim", "python", "latex", "gitignore", "json", "tsx", "html" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    -- Set parser installation directory
    parser_install_dir = parser_install_dir,

    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true }
}
