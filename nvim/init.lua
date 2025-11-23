require("tess/remap")
require("tess/set")
require("plugins")
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.o.mouse = 'a'

local function is_modified_buffer_open(buffers)
    for _, v in pairs(buffers) do
        if v.name:match("NvimTree_") == nil then
            return true
        end
    end
    return false
end

local function only_special_buffers_open()
    -- Check all visible windows instead of all loaded buffers
    local wins = vim.api.nvim_list_wins()

    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
        local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

        -- Skip special buffers
        local is_nvim_tree = bufname:match("NvimTree_") ~= nil
        local is_terminal = buftype == "terminal"
        local is_codecompanion = filetype == "codecompanion"
        local is_special = is_nvim_tree or is_terminal or is_codecompanion

        -- If we find a normal buffer window (not special)
        if not is_special and buftype == "" then
            return false
        end
    end

    return true
end

vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if
            #vim.api.nvim_list_wins() == 1
            and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
            and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
        then
            vim.cmd("quit")
        end
    end,
})

-- Close Neovim when only NvimTree and toggleterm are open
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout", "WinClosed", "QuitPre" }, {
    callback = function()
        -- Delay the check to let the buffer/window actually close
        vim.defer_fn(function()
            if only_special_buffers_open() then
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

