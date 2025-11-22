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
    local buffers = vim.api.nvim_list_bufs()
    local normal_buffer_found = false

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local bufname = vim.api.nvim_buf_get_name(buf)
            local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')

            -- Skip NvimTree and toggleterm buffers
            if not bufname:match("NvimTree_") and buftype ~= "terminal" then
                -- Check if it's a real file buffer
                if buftype == "" and (bufname ~= "" or vim.api.nvim_buf_get_option(buf, 'modified')) then
                    normal_buffer_found = true
                    break
                end
            end
        end
    end

    return not normal_buffer_found
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
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        if only_special_buffers_open() then
            vim.cmd("qall")
        end
    end,
})
local undodir = vim.fn.stdpath('data') .. '/undo'
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
end

vim.opt.undofile = true
vim.opt.undodir = undodir
print("hiiii")
