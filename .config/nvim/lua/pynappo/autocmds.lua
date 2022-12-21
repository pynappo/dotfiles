local api = vim.api
local autocmd = api.nvim_create_autocmd
api.nvim_create_augroup("pynappo", { clear = true })
if vim.g.started_by_firenvim then
  autocmd('BufEnter', {
    callback = function()
      vim.cmd('startinsert')
    end,
    group = 'pynappo'
  })
end

autocmd ('TextYankPost',{
  callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end,
  group = 'pynappo'
})
  -- use { 'j-hui/fidget.nvim', config = function() require("fidget").setup({ window = { blend = 0 }}) end }

autocmd("BufWritePre", {
  command = [[%s/\s\+$//e]],
  group = 'pynappo'
})
autocmd('BufReadPost',  {
  group    = 'pynappo',
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

autocmd('DiagnosticChanged', {
  group = 'pynappo',
  callback = function() vim.diagnostic.setloclist({ open = false }) end,
})
