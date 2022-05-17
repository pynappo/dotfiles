local api = vim.api
local autocmd = api.nvim_create_autocmd
local pynappo = api.nvim_create_augroup('Pynappo', { clear = true })

autocmd('BufWritePre', {
  group = pynappo,
  pattern = '*',
  callback = function() vim.lsp.buf.formatting_sync() end
})

autocmd('BufEnter', {
  group = pynappo,
  pattern = '*.txt',
  callback = function()
    if vim.bo.buftype == 'help' then
      api.nvim_command('wincmd L')
      api.nvim_buf_set_keymap(0, 'n', 'q', '<CMD>q<CR>', { noremap = true })
    end
  end,
})

autocmd('TextYankPost', {
  group = pynappo,
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})
