require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = false,
    insert_mappings = true,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    shell = vim.o.shell,
})

-- Open toggleterm on startup and focus back to main window
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        vim.cmd("ToggleTerm")
        -- Focus back to the main editing window (move right past NvimTree)
        vim.cmd("wincmd k")
        vim.cmd("wincmd l")
    end
})
