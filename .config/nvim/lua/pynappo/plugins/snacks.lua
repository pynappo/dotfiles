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
            { section = 'keys', gap = 1, padding = 1 },
            { section = 'recent_files', cwd = true },
            { section = 'startup' },
            {
              pane = 2,
              icon = ' ',
              desc = 'Browse Repo',
              padding = 1,
              key = 'b',
              action = function() Snacks.gitbrowse() end,
            },
            function()
              local in_git = Snacks.git.get_root() ~= nil
              local cmds = {
                {
                  title = 'Notifications',
                  cmd = 'gh notify -s -a -n5',
                  action = function() vim.ui.open('https://github.com/notifications') end,
                  key = 'n',
                  icon = ' ',
                  height = 5,
                  enabled = true,
                },
                {
                  title = 'Open Issues',
                  cmd = 'gh issue list -L 3',
                  key = 'i',
                  action = function() vim.fn.jobstart('gh issue list --web', { detach = true }) end,
                  icon = ' ',
                  height = 7,
                },
                {
                  icon = ' ',
                  title = 'Open PRs',
                  cmd = 'gh pr list -L 3',
                  key = 'p',
                  action = function() vim.fn.jobstart('gh pr list --web', { detach = true }) end,
                  height = 7,
                },
                {
                  icon = ' ',
                  title = 'Git Status',
                  cmd = 'git --no-pager diff --stat -B -M -C',
                  height = 10,
                },
              }
              return vim
                .iter(cmds)
                :map(
                  function(cmd)
                    return vim.tbl_extend('force', {
                      pane = 2,
                      section = 'terminal',
                      enabled = in_git,
                      padding = 1,
                      ttl = 5 * 60,
                      indent = 3,
                    }, cmd)
                  end
                )
                :totable()
            end,
          },
        },
        profiler = {
          enabled = true,
          globals = {
            'vim',
            'vim.api',
            'vim.uv',
            'vim.loop',
          },
        },
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        terminal = { enabled = true },
        scratch = { enabled = true },
        picker = {
          enabled = true,
        },
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
      vim.print = function(...)
        require('snacks').debug.inspect(...)
        return ...
      end
      _G.backtrace = Snacks.debug.backtrace
      _G.bt = Snacks.debug.backtrace
      vim.api.nvim_create_user_command('Notifications', function() Snacks.notifier.show_history() end, {})
      vim.api.nvim_create_user_command('ScratchPick', function() Snacks.scratch.select() end, {})
      vim.api.nvim_create_user_command('Dashboard', function() Snacks.dashboard.open() end, {})
      -- Toggle the profiler
      Snacks.toggle.profiler():map('<leader>pp')
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map('<leader>ph')
      vim.api.nvim_create_user_command('ScratchProfile', function() Snacks.profiler.scratch() end, {})
      vim.keymap.set('n', '<leader>uC', function() Snacks.picker.colorschemes() end, { desc = 'Colorschemes' })
      vim.keymap.set('n', '<leader>fu', function() Snacks.picker.colorschemes() end, { desc = 'Colorschemes' })
    end,
  },
}
