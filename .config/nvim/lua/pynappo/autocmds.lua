local M = {}
local pynappo = vim.api.nvim_create_augroup("pynappo", { clear = true })
M.create_autocmd = function(event, opts)
  if opts.group == nil then opts.group = pynappo end
  vim.api.nvim_create_autocmd(event, opts)
end
if vim.g.started_by_firenvim then
  M.create_autocmd('BufEnter', {
    callback = function() vim.cmd.startinsert() end,
    group = pynappo
  })
end

M.create_autocmd ('TextYankPost',{
  callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end,
})
M.create_autocmd("BufWritePre", {
  command = [[%s/\s\+$//e]],
})

M.create_autocmd('BufReadPost',  {
  pattern  = '*',
  callback = function()
    local fn = vim.fn
    if fn.line("'\"") > 0 and fn.line("'\"") <= fn.line("$") then
      fn.setpos('.', fn.getpos("'\""))
      vim.cmd('normal zz')
      vim.cmd('silent! foldopen')
    end
  end
})

M.create_autocmd('DiagnosticChanged', {
  callback = function() vim.diagnostic.setloclist({ open = false }) end,
})

if not vim.g.neovide then
  M.create_autocmd('ColorScheme', {
    callback = function()
      require('pynappo/theme').transparent_override()
    end
  })
end

return M
