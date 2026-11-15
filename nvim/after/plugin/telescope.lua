local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- git_files errors outside a repository; fall back to plain find_files there.
vim.keymap.set('n', '<C-p>', function()
	if not pcall(builtin.git_files) then
		builtin.find_files()
	end
end)
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
-- Live grep as you type (needs ripgrep)
vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = "Live grep" })
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "Open buffers" })
vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = "Help pages" })
vim.keymap.set('n', '<leader>pk', builtin.keymaps, { desc = "Keymaps" })
