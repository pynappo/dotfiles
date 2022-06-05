local api = vim.api
local autocmd = api.nvim_create_autocmd
local pynappo = api.nvim_create_augroup('Pynappo', { clear = true })

autocmd('BufWritePre', {
  group = pynappo,
  pattern = '*',
  callback = function() vim.lsp.buf.formatting_sync() end
})

autocmd('TextYankPost', {
  group = pynappo,
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})
