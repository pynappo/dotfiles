local api = vim.api
local autocmd = api.nvim_create_autocmd
local pynappo = api.nvim_create_augroup("Pynappo", { clear = true })

if vim.g.started_by_firenvim then
  autocmd('BufEnter', {
    callback = function()
      vim.wo.spell = true
      vim.cmd('startinsert')
    end,
    group = pynappo
  })
end

