-- template from https://lazy.folke.io/developers#reprolua, feel free to replace if you have your own minimal init.lua
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.o.number = true
vim.g.mapleader = ' '
vim.opt.rtp:prepend(lazypath)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('lazy').setup({
  spec = {
    {
      'nvim-neo-tree/neo-tree.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
    },

    {
      'folke/snacks.nvim',
      config = function()
        local Snacks = require('snacks')
        Snacks.setup({
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
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
          image = { enabled = true },
        })
        vim.notify = Snacks.notifier.notify
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
        vim.print = Snacks.debug.inspect
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
      end,
    },
  },
  dev = {
    fallback = true,
    path = '~/code/nvim',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = { 'pynappo', 'neo-tree.nvim' }, -- For example {"folke"}
  },
  disabled_plugins = {
    -- 'matchit',
    -- 'matchparen',
    -- 'netrw',
    -- 'netrwPlugin',
    -- 'netrwSettings',
    -- 'netrwFileHandlers',
    -- 'gzip',
    -- 'zip',
    -- 'zipPlugin',
    -- 'tar',
    -- 'tarPlugin',
    -- 'getscript',
    -- 'getscriptPlugin',
    -- 'vimball',
    -- 'vimballPlugin',
    -- '2html_plugin',
    -- 'logipat',
    -- 'rrhelper',
  },
})
