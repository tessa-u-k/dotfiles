-- disable netrw before anything else loads
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("tess/remap")
require("tess/set")
require("plugins")
vim.o.mouse = 'a'

local function is_tree(buf)
    return vim.api.nvim_buf_get_name(buf):match("NvimTree_") ~= nil
end

-- Modified file buffers, including hidden ones (terminals don't count).
local function has_unsaved_buffers()
    for _, info in ipairs(vim.fn.getbufinfo({ bufmodified = 1 })) do
        if vim.bo[info.bufnr].buftype == "" and not is_tree(info.bufnr) then
            return true
        end
    end
    return false
end

-- True when every remaining window is NvimTree, a terminal or the AI chat.
-- Anything else (a file, :help, quickfix, ...) keeps the session alive.
local function only_special_buffers_open()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local is_special = is_tree(buf)
            or vim.bo[buf].buftype == "terminal"
            or vim.bo[buf].filetype == "codecompanion"
        if not is_special then
            return false
        end
    end
    return true
end

vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and is_tree(0) and not has_unsaved_buffers() then
            vim.cmd("quit")
        end
    end,
})

-- Close Neovim when only NvimTree, toggleterm and the AI chat are left.
-- Never when a hidden buffer still has unsaved changes: `qall!` would
-- silently throw them away.
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout", "WinClosed", "QuitPre" }, {
    callback = function()
        -- Delay the check to let the buffer/window actually close
        vim.defer_fn(function()
            if only_special_buffers_open() and not has_unsaved_buffers() then
                vim.cmd("qall!")
            end
        end, 50)
    end,
})

local undodir = vim.fn.stdpath('data') .. '/undo'
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
end

vim.opt.undofile = true
vim.opt.undodir = undodir
