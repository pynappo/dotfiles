local map = vim.keymap.set
local ts = require('telescope.builtin')

-- Remap space as leader key
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local mappings = {
  ['n'] = {
    { 'x', '"_x' },
    { 'j', 'gj' },
    { 'k', 'gk' },
    -- Better pasting
    { 'p', 'p=`]' },
    { 'P', 'P=`]' },
    { '<leader>p', '"+p=`]' },
    -- Telescope
    { '<leader><space>', ts.buffers, {desc = '(TS) Buffers'}},
    { '<leader>ff', ts.find_files, {desc = '(TS) Find files'}},
    { '<leader>fb', ts.current_buffer_fuzzy_find, {desc = '(TS) Fuzzy find in buffer'}},
    { '<leader>fh', ts.help_tags, {desc = '(TS) Neovim help'}},
    { '<leader>ft', ts.tags , {desc = '(TS) Tags'}},
    { '<leader>fd', ts.grep_string, {desc = '(TS) grep a string'}},
    { '<leader>fp', ts.live_grep, {desc = '(TS) live grep a string'}},
    { '<leader>fo', [[ts.tags { only_current_buffer = true }]], {desc = '(TS) Tags in buffer'}},
    { '<leader>?', ts.oldfiles, {desc = '(TS) Oldfiles'}},
    -- Diagnostics
    { '<leader>e', vim.diagnostic.open_float, {desc = 'Floating Diagnostics'}},
    { '[d', vim.diagnostic.goto_prev, {desc = 'Previous diagnostic'}},
    { ']d', vim.diagnostic.goto_next, {desc = 'Next diagnostic'}},
    { '<leader>q', vim.diagnostic.setloclist, {desc = 'Add diagnostics to location list'}},
    -- Better window navigation
    { '<C-j>', '<C-w>j' },
    { '<C-k>', '<C-w>k' },
    { '<C-h>', '<C-w>h' },
    { '<C-l>', '<C-w>l' },
    -- Neotree
    { '<leader>n', ':Neotree toggle left reveal_force_cwd<CR>', {desc = '(NT) CWD file tree (left) '}},
    { '<leader>b', ':Neotree toggle show buffers right<CR>', {desc = '(NT) Buffers (right)'}},
    { '<leader>g', ':Neotree float git_status<CR>', {desc = '(NT) Floating git status'} },
    -- Incrementally rename
    { '<leader>rn', ':IncRename', {desc = 'Rename (incrementally)'}},
    { 'gb', ':BufferLinePick<CR>'}
  }
}

for mode, mapping in pairs(mappings) do
  for _, m in pairs(mapping) do
    map(mode, m[1], m[2], m[3])
  end
end


