return {
  {
    'folke/snacks.nvim',
    dev = true,
    priority = 20000,
    config = function()
      local Snacks = require('snacks')
      Snacks.setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        dashboard = {
          sections = {
            { section = 'header' },
            {
              pane = 2,
              section = 'terminal',
              cmd = 'colorscript -e square',
              height = 5,
              padding = 1,
            },
            { section = 'keys', gap = 1, padding = 1 },
            {
              pane = 2,
              icon = ' ',
              title = 'Recent Files',
              section = 'recent_files',
              cwd = true,
              indent = 2,
              padding = 1,
            },
            { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
            {
              pane = 2,
              icon = ' ',
              title = 'Git Status',
              section = 'terminal',
              enabled = function() return Snacks.git.get_root() ~= nil end,
              cmd = 'git status --short --branch --renames',
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { section = 'startup' },
          },
        },
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        terminal = { enabled = true },
        scratch = { enabled = true },
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
      })
      vim.api.nvim_create_user_command('RenameFile', function() Snacks.rename.rename_file() end, {})
      vim.api.nvim_create_user_command('Scratch', function() Snacks.scratch.open({}) end, {})
      vim.api.nvim_create_user_command(
        'ScratchLua',
        function()
          Snacks.scratch.open({
            ft = 'lua',
          })
        end,
        {}
      )
      vim.api.nvim_create_user_command('ScratchPick', function() Snacks.scratch.select() end, {})
      -- Toggle the profiler
      Snacks.toggle.profiler():map('<leader>pp')
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map('<leader>ph')
    end,
  },
}
