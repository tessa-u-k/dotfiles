vim.opt.termguicolors = true
require("bufferline").setup{
    options = {
        offsets = {
            {
                filetype = "NvimTree",
                separator = true
            }
        }
    }
}
