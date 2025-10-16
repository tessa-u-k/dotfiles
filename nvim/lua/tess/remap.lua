vim.g.mapleader = " "
vim.keymap.set("n", "<leader>t", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>ft", vim.cmd.FloatermToggle)
-- tabs :)
vim.keymap.set("n", "<leader>l", vim.cmd.BufferLineCycleNext)
vim.keymap.set("n", "<leader>h", vim.cmd.BufferLineCyclePrev)
vim.keymap.set("n", "<leader>L", vim.cmd.BufferLineMoveNext)
vim.keymap.set("n", "<leader>H", vim.cmd.BufferLineMovePrev)
