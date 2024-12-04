return {
  {
    'folke/snacks.nvim',
    priority = 20000,
    config = function()
      local snacks = require('snacks')
      snacks.setup({
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
            { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
            { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
            {
              pane = 2,
              icon = ' ',
              title = 'Git Status',
              section = 'terminal',
              enabled = function() return snacks.git.get_root() ~= nil end,
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
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
      })
      vim.api.nvim_create_user_command('RenameFile', function() snacks.rename.rename_file() end, {})
      -- Toggle the profiler
      Snacks.toggle.profiler():map('<leader>pp')
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map('<leader>ph')
    end,
  },
}
