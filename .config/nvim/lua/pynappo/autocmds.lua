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

autocmd( {"VimEnter"} , {
  callback = function()
    local cwd = vim.fn.getcwd()
    if string.find(cwd, '.files') or string.find(cwd, '.config') then
      vim.env.GIT_WORK_TREE = vim.fn.expand("~")
      vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles.git/")
    end
  end
})

autocmd({"DirChanged"}, {
  callback = function ()
    local cwd = vim.v.event.cwd
    if string.find(cwd, '.files') or string.find(cwd, '.config') then
      vim.env.GIT_WORK_TREE = vim.fn.expand("~")
      vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles.git/")
    else
      vim.env.GIT_WORK_TREE = nil
      vim.env.GIT_DIR = nil
    end
  end,
  group = pynappo
})
