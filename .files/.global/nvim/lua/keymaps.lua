local map = vim.keymap.set
map({ 'i', 'v' }, ';;', '<Esc>')
--Remap space as leader key
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
map('n', '<leader>cd', ':cd %:p:h')

-- Telescope
local ts = require('telescope.builtin')
map('n', '<leader><space>', ts.buffers)
map('n', '<leader>sf', function()
  ts.find_files { previewer = false }
end)
map('n', '<leader>sb', ts.current_buffer_fuzzy_find)
map('n', '<leader>sh', ts.help_tags)
map('n', '<leader>st', ts.tags)
map('n', '<leader>sd', ts.grep_string)
map('n', '<leader>sp', ts.live_grep)
map('n', '<leader>so', function()
  ts.tags { only_current_buffer = true }
end)
map('n', '<leader>?', ts.oldfiles)


-- Diagnostics
map('n', '<leader>e', vim.diagnostic.open_float)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<leader>q', vim.diagnostic.setloclist)

-- Better window navigation
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')

-- NvimTree
map('n', '<C-n>', ':NvimTreeToggle<CR>')
map('n', '<leader>f', ':NvimTreeRefresh<CR>')
map('n', '<leader>n', ':NvimTreeFindFile<CR>')

-- Minimap
map('n', '<leader>m', ':MinimapToggle<CR>')
