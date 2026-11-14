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
