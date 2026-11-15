-- nvim-treesitter (`main` branch): the plugin only installs parsers and
-- ships queries; highlighting and indentation are enabled per buffer below.
-- Parsers are installed to stdpath("data")/site.
local ok, ts = pcall(require, "nvim-treesitter")
if not ok or not ts.install then
    return
end

-- Parsers to keep installed (no-op for those already present).
ts.install({
    "rust", "javascript", "typescript", "cpp", "c", "lua", "vim", "python",
    "gitignore", "json", "tsx", "html", "nix", "latex",
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
    callback = function(args)
        -- Fails (silently) for filetypes without an installed parser.
        if not pcall(vim.treesitter.start, args.buf) then
            return
        end
        -- Only use treesitter indentation where the language has indent queries.
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and vim.treesitter.query.get(lang, "indents") then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
