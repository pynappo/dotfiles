local utils = require('pynappo.utils')
local normalize_system_command = function(cmd)
  return utils.is_windows and vim.list_extend({ 'pwsh', '-NoProfile', '-c' }, cmd) or cmd
end
local print_system_command = function(cmd)
  local result = vim.system(normalize_system_command(cmd), { cwd = vim.fn.getcwd(), text = true }):wait()
  print(result.stdout:gsub('%%', [[\]]))
end
local commands = {
  { "CDhere", "tcd %:p:h" },
  {
    "DotfilesGit",
    function()
      vim.env.GIT_WORK_TREE = vim.fn.expand("~")
      vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles.git/")
    end,
  },
  {
    'SwapFiles',
    function(args)
      local command_map = { list = 'ls', remove = 'rm' }
      if utils.truthy(args.args) and not command_map[args.args] then
        vim.notify('SwapFiles: not a valid argument', vim.log.levels.ERROR)
        return
      end
      local command = command_map[args.args] or command_map.list
      local modifiers = (args.bang and args.args == 'remove') and (utils.is_windows and '-Force' or '-f') or nil
      print_system_command({ command, vim.fn.stdpath('data') .. '/swap/*', modifiers })
    end,
    {
      nargs = '?',
      bang = true,
      complete = function()
        return {
          'list',
          'remove'
        }
      end
    }
  },
  {
    'Config',
    function(args)
      local new_tab = utils.truthy(args.args) and args.args == 'tab'
      if new_tab then vim.cmd.tabnew() end
      vim.cmd.tcd((vim.env.XDG_CONFIG_HOME or '~/.config') .. '/nvim/')
      require('tabnames').set_tab_name(0, 'Config')
      if new_tab then vim.cmd('Alpha') end
    end
  },
  {
    'Messages',
    function()
      local scratch_buffer = vim.api.nvim_create_buf(false, true)
      vim.bo[scratch_buffer].filetype = 'vim'
      local messages = vim.split(vim.fn.execute('messages', "silent"), '\n')
      vim.api.nvim_buf_set_text(scratch_buffer, 0, 0, 0, 0, messages)
      vim.cmd('vertical sbuffer ' .. scratch_buffer)
    end,
  },
  {
    'DiffOrig',
    function()
      local scratch_buffer = vim.api.nvim_create_buf(false, true)
      local current_ft = vim.bo.filetype
      vim.cmd('vertical sbuffer' .. scratch_buffer)
      vim.bo[scratch_buffer].filetype = current_ft
      vim.cmd('read ++edit #') -- load contents of previous buffer into scratch_buffer
      vim.cmd.normal('1G"_d_') -- delete extra newline at top of scratch_buffer
      vim.cmd.diffthis() -- scratch_buffer
      vim.cmd.wincmd('p')
      vim.cmd.diffthis() -- current buffer
    end
  }
}
for _, cmd in ipairs(commands) do
  vim.api.nvim_create_user_command(
    cmd[1],
    type(cmd[2]) == 'table' and function() print_system_command(cmd[2]) end or cmd[2],
    cmd[3] or {}
  )
end
