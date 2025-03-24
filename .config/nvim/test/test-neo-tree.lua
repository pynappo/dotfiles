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
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  spec = {
    -- {
    --   'nvim-neo-tree/neo-tree.nvim',
    --   dependencies = {
    --     'nvim-lua/plenary.nvim',
    --     'nvim-tree/nvim-web-devicons',
    --     'MunifTanjim/nui.nvim',
    --     -- "3rd/image.nvim",  -- delay until needed
    --   },
    --   enabled = false,
    --   ---@module "neo-tree"
    --   ---@type neotree.Config
    --   opts = {
    --     default_component_configs = {
    --       symlink_target = {
    --         enabled = true,
    --       },
    --     },
    --     filesystem = {
    --       bind_to_cwd = false,
    --       window = {
    --         mappings = {
    --           ['Esc'] = 'close_window',
    --           ['l'] = 'open',
    --           ['_'] = function(state) vim.print(state.tree:get_node()) end,
    --         },
    --       },
    --       follow_current_file = {
    --         enabled = true,
    --       },
    --     },
    --   },
    -- },
    {
      'nvim-neo-tree/neo-tree.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'muniftanjim/nui.nvim', -- "3rd/image.nvim", -- optional image support in preview window: see `# preview mode` for more information
      },

      keys = {
        {
          '<leader>e',
          function()
            local reveal_file = vim.fn.expand('%:p')
            if reveal_file == '' then
              reveal_file = vim.fn.getcwd()
            else
              local f = io.open(reveal_file, 'r')
              if f then
                f:close()
              else
                reveal_file = vim.fn.getcwd()
              end
            end
            require('neo-tree.command').execute({
              toggle = true,
              reveal = true,
              reveal_file = reveal_file,
              reveal_force_cwd = true,
              source = 'filesystem',
              position = 'left',
            })
          end,
          desc = 'Neotree',
        },
      },
      -- opts = {}
      config = function()
        require('neo-tree').setup({
          event_handlers = {
            {
              event = 'after_render',
              handler = function()
                local state = require('neo-tree.sources.manager').get_state('filesystem')
                if not require('neo-tree.sources.common.preview').is_active() then
                  state.config = { use_float = false } -- or whatever your config is
                  state.commands.toggle_preview(state)
                end
              end,
            },
          },
        })
      end,
    },
    --   {
    --     'folke/snacks.nvim',
    --     config = function()
    --       local Snacks = require('snacks')
    --       Snacks.setup({
    --         -- your configuration comes here
    --         -- or leave it empty to use the default settings
    --         -- refer to the configuration section below
    --         profiler = {
    --           enabled = true,
    --           globals = {
    --             'vim',
    --             'vim.api',
    --             'vim.uv',
    --             'vim.loop',
    --           },
    --         },
    --         bigfile = { enabled = true },
    --         notifier = { enabled = true },
    --         quickfile = { enabled = true },
    --         terminal = { enabled = true },
    --         scratch = { enabled = true },
    --       })
    --       vim.notify = Snacks.notifier.notify
    --       vim.api.nvim_create_autocmd('User', {
    --         pattern = 'MiniFilesActionRename',
    --         callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
    --       })
    --       vim.api.nvim_create_user_command('RenameFile', function() Snacks.rename.rename_file() end, {})
    --       vim.api.nvim_create_user_command('Scratch', function() Snacks.scratch.open({}) end, {})
    --       vim.api.nvim_create_user_command(
    --         'ScratchLua',
    --         function()
    --           Snacks.scratch.open({
    --             ft = 'lua',
    --           })
    --         end,
    --         {}
    --       )
    --       vim.print = Snacks.debug.inspect
    --       _G.backtrace = Snacks.debug.backtrace
    --       _G.bt = Snacks.debug.backtrace
    --       vim.api.nvim_create_user_command('Notifications', function() Snacks.notifier.show_history() end, {})
    --       vim.api.nvim_create_user_command('ScratchPick', function() Snacks.scratch.select() end, {})
    --       vim.api.nvim_create_user_command('Dashboard', function() Snacks.dashboard.open() end, {})
    --       -- Toggle the profiler
    --       Snacks.toggle.profiler():map('<leader>pp')
    --       -- Toggle the profiler highlights
    --       Snacks.toggle.profiler_highlights():map('<leader>ph')
    --       vim.api.nvim_create_user_command('ScratchProfile', function() Snacks.profiler.scratch() end, {})
    --     end,
    --   },
  },
  dev = {
    fallback = true,
    path = '~/code/nvim',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = { 'pynappo', 'neo-tree.nvim' }, -- For example {"folke"}
  },
})

vim.o.number = true
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle reveal left<CR>')
vim.keymap.set('n', '<leader>E', '<Cmd>Neotree filesystem reveal float<CR>', {})
vim.api.nvim_create_user_command('Debug', function()
  local bufnrs = vim.api.nvim_list_bufs()
  local bufs = {}
  for _, bufnr in pairs(bufnrs) do
    bufs[bufnr] = { vim.api.nvim_buf_get_name(bufnr) }
  end
  local winnrs = vim.api.nvim_list_wins()
  local wins = {}
  for _, winnr in pairs(winnrs) do
    wins[winnr] = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(winnr))
  end
  vim.print(bufs)
  vim.print(wins)
end, {})
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.bo.buftype == '' then vim.cmd('Neotree close') end
  end,
})
