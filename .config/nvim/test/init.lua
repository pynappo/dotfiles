local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true, }
keymap("i", "<c-CR>", "<ESC>o", opts)
keymap("i", "<c-S-CR>", "<ESC>O", opts)
