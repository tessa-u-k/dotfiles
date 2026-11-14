local M = {}

local minimal_filetypes = {
    gitcommit = true,
    gitrebase = true,
    gitsendemail = true,
}

-- Whether to open the tree + terminal layout on startup. Skipped when nvim is
-- only being used as git's editor (commit messages, interactive rebases).
function M.wanted()
    return not minimal_filetypes[vim.bo.filetype]
end

return M
