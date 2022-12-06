local augroup_name = 'murmur'
vim.api.nvim_create_augroup('murmur', { clear = true })
require('murmur').setup {
  max_len = 80, -- maximum word-length to highlight
  exclude_filetypes = {},
  callbacks = {
    function ()
      vim.cmd.doautocmd('InsertEnter')
      vim.w.diag_shown = false
    end,
  }
}
vim.api.nvim_create_autocmd('CursorHold', {
  group = augroup_name,
  pattern = '*',
  callback = function ()
    if not vim.w.diag_shown and vim.w.cursor_word ~= '' then
      vim.diagnostic.open_float(nil, {
        focusable = true,
        close_events = { 'InsertEnter' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      })
      vim.w.diag_shown = true
    end
  end
})
