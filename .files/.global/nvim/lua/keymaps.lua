local map=vim.keymap.set
map({ 'n', 'v' }, ';;', '<Esc>')
--Remap space as leader key
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


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

-- LSP
local lsp = vim.lsp
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  map('n', 'gD', lsp.buf.declaration, opts)
  map('n', 'gd', lsp.buf.definition, opts)
  map('n', 'K', lsp.buf.hover, opts)
  map('n', 'gi', lsp.buf.implementation, opts)
  map('n', '<C-k>', lsp.buf.signature_help, opts)
  map('n', '<leader>wa', lsp.buf.add_workspace_folder, opts)
  map('n', '<leader>wr', lsp.buf.remove_workspace_folder, opts)
  map('n', '<leader>wl', function()
    vim.inspect(lsp.buf.list_workspace_folders())
  end, opts)
  map('n', '<leader>D', lsp.buf.type_definition, opts)
  map('n', '<leader>rn', lsp.buf.rename, opts)
  map('n', 'gr', lsp.buf.references, opts)
  map('n', '<leader>ca', lsp.buf.code_action, opts)
  map('n', '<leader>so', ts.lsp_document_symbols, opts)
  vim.api.nvim_create_user_command("Format", lsp.buf.formatting, {})
end

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
map('n', '<C-n>', ':NvimTreeToggle<CR>')            -- open/close
map('n', '<leader>f', ':NvimTreeRefresh<CR>')       -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>')      -- search file
