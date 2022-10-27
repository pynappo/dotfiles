local api = vim.api
local autocmd = api.nvim_create_autocmd
local pynappo = api.nvim_create_augroup("Pynappo", { clear = true })
if vim.g.started_by_firenvim then
  autocmd('BufEnter', {
    callback = function()
      vim.cmd('startinsert')
    end,
    group = pynappo
  })
end

autocmd ('TextYankPost',{
  callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end,
  group = pynappo
})

autocmd({ "BufWritePre" }, {
  command = [[%s/\s\+$//e]],
  group = pynappo
})
