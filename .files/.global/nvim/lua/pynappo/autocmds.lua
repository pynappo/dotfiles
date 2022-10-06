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

autocmd ('TextYankPost',{
  callback = function () vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end,
  group = pynappo
})

autocmd({ "BufWritePre" }, {
  command = [[%s/\s\+$//e]],
  group = pynappo
})

autocmd( {"VimEnter"} , {
  callback = function()
    if string.find(vim.fn.getcwd(), '.files') then
      vim.env.GIT_WORK_TREE = vim.fn.expand("~")
      vim.env.GIT_DIR = vim.fn.expand("~/.files")
    end
  end
})
autocmd({ "DirChanged" }, {
  callback = function ()
    if string.find(vim.v.event.cwd, '.files') then
      vim.env.GIT_WORK_TREE = vim.fn.expand("~")
      vim.env.GIT_DIR = vim.fn.expand("~/.files")
    else
      vim.env.GIT_WORK_TREE = nil
      vim.env.GIT_DIR = nil
    end
  end,
  group = pynappo
})


