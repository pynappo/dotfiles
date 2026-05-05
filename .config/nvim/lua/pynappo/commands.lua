local utils = require('pynappo.utils')
local start = vim.fn.getcwd()
vim.api.nvim_create_user_command('CDhere', 'tcd %:p:h', {})
vim.api.nvim_create_user_command('DotfilesGit', function()
  vim.env.GIT_WORK_TREE = vim.fn.expand('~')
  vim.env.GIT_DIR = vim.fn.expand('~/.files.git/')
end, {})

vim.api.nvim_create_user_command('SwapFiles', function(ctx)
  local command_map = { list = 'ls', remove = 'rm' }
  if utils.truthy(ctx.args) and not command_map[ctx.args] then
    vim.notify('SwapFiles: not a valid argument', vim.log.levels.ERROR)
    return
  end
  local command = command_map[ctx.args] or command_map.list
  local mods = {}
  if ctx.bang and ctx.args == 'remove' then table.insert(mods, utils.is_windows and '-Force' or '-f') end
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.system({ command, vim.fs.joinpath(vim.fn.stdpath('data'), '/swap/*') }, {
    stdout = function(out) vim.notify(out) end,
  })
end, {
  nargs = '?',
  bang = true,
  complete = function()
    return {
      'list',
      'remove',
    }
  end,
})
vim.api.nvim_create_user_command('Config', function(ctx)
  local new_tab = utils.truthy(ctx.args) and ctx.args == 'tab'
  if new_tab then vim.cmd.tabnew() end
  vim.cmd.tcd(vim.fn.stdpath('config'))
  require('tabnames').set_tab_name(0, 'Config')
  if new_tab then vim.cmd('Alpha') end
end, {})
vim.api.nvim_create_user_command('Messages', function()
  local scratch_buffer = vim.api.nvim_create_buf(false, true)
  vim.bo[scratch_buffer].filetype = 'vim'
  local messages = vim.split(vim.fn.execute('messages', 'silent'), '\n')
  vim.api.nvim_buf_set_text(scratch_buffer, 0, 0, 0, 0, messages)
  vim.cmd('vertical sbuffer ' .. scratch_buffer)
end, {})
vim.api.nvim_create_user_command('DiffOrig', function()
  local scratch_buffer = vim.api.nvim_create_buf(false, true)
  local current_ft = vim.bo.filetype
  vim.cmd('vertical sbuffer' .. scratch_buffer)
  vim.bo[scratch_buffer].filetype = current_ft
  vim.cmd('read ++edit #') -- load contents of previous buffer into scratch_buffer
  vim.cmd.normal('1G"_d_') -- delete extra newline at top of scratch_buffer
  vim.cmd.diffthis() -- scratch_buffer
  vim.cmd.wincmd('p')
  vim.cmd.diffthis() -- current buffer
end, {})
vim.api.nvim_create_user_command('CDRoot', function(args)
  -- check lsp root dirs
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, c in ipairs(clients) do
    if utils.truthy(c.root_dir) then
      vim.cmd.tcd(c.root_dir)
      return
    end
  end
  -- check for .git above bufnr
  local root = vim.fs.root(0, { '.git' })
  if not root then
    vim.notify('could not find a root_dir for this buffer')
    return
  end

  return root
end, {})
vim.api.nvim_create_user_command(
  'Debug',
  function(_)
    vim.print({
      win = vim.api.nvim_get_current_win(),
      buf = vim.api.nvim_get_current_buf(),
    })
  end,
  {}
)
vim.api.nvim_create_user_command('CDStart', function(_) vim.cmd.cd(start) end, {})
vim.api.nvim_create_user_command('MiniTestFile', function(_) MiniTest.run_file() end, {})
vim.api.nvim_create_user_command('MiniTestHere', function(_) MiniTest.run_at_location() end, {})
