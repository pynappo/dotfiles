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
    { import = 'pynappo.plugins.lsp' },
    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v3.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        {
          's1n7ax/nvim-window-picker',
          version = '2.*',
          config = function()
            require('window-picker').setup({
              filter_rules = {
                include_current_win = false,
                autoselect_one = true,
                -- filter using buffer options
                bo = {
                  -- if the file type is one of following, the window will be ignored
                  filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                  -- if the buffer type is one of following, the window will be ignored
                  buftype = { 'terminal', 'quickfix' },
                },
              },
            })
          end,
        },
      },
      -- opts = {}
      config = function()
        require('neo-tree').setup({
          sources = {
            'filesystem',
            'document_symbols',
          },
          source_selector = {
            winbar = true,
            sources = {
              { source = 'filesystem' },
              { source = 'document_symbols' },
            },
          },
          auto_clean_after_session_restore = true,
          close_if_last_window = true,
          default_component_configs = {
            indent = {
              padding = 0,
            },
            file_size = {
              enabled = false,
            },
            type = {
              enabled = false,
            },
            last_modified = {
              enabled = false,
            },
          },
          window = {
            width = 25,
            auto_expand_width = false,
            mappings = {
              ['<bs>'] = 'next_source',
              ['<esc>'] = 'cancel',
              ['r'] = 'rename',
              ['q'] = 'close_window',
            },
          },
          filesystem = {
            follow_current_file = {
              enabled = true,
              leave_dirs_open = false,
            },
            hijack_netrw_behavior = 'open_default',
            window = {
              mappings = {
                ['<2-LeftMouse>'] = 'open_with_window_picker',
                ['<cr>'] = 'open_with_window_picker',
                ['a'] = 'add',
                ['y'] = 'copy_to_clipboard',
                ['s'] = 'split_with_window_picker',
                ['v'] = 'vsplit_with_window_picker',
                ['.'] = 'set_root',
                ['x'] = 'cut_to_clipboard',
                ['p'] = 'paste_from_clipboard',
                ['d'] = 'delete',
              },
            },
          },
          document_symbols = {
            follow_cursor = true,
            renderers = {
              root = {
                { 'icon', default = 'C' },
                { 'name', zindex = 10 },
              },
              symbol = {
                { 'indent', with_expanders = true },
                { 'kind_icon', default = '?' },
                {
                  'container',
                  content = {
                    { 'name', zindex = 10 },
                  },
                },
              },
            },
            window = {
              mappings = {
                ['<cr>'] = 'jump_to_symbol',
                ['<2-LeftMouse>'] = 'jump_to_symbol',
              },
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
