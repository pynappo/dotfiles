-- install lazy.nvim, a plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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

-- some nice-to-have settings
vim.cmd.colorscheme('habamax')
local o = vim.opt
local g = vim.g
o.smartcase = true
o.cursorline = true
o.vartabstop = '2'
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true
o.timeoutlen = 2000
o.list = true
o.listchars = {
  lead = '.',
  eol = '󱞣',
}
g.mapleader = ' '
o.relativenumber = true
o.number = true
-- setup plugins
require('lazy').setup({
  { 'tpope/vim-fugitive' },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            -- '.git',
            -- '.DS_Store',
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
    },
    config = function()
      require('neo-tree').setup({
        event_handlers = {
          {
            event = 'file_opened',
            handler = function(file_path)
              vim.print('hi')
              require('neo-tree').close_all()
            end,
          },
        },
      })
    end,
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   event = { 'BufNewFile', 'BufReaPost' },
  --   build = function()
  --     if not vim.env.GIT_WORK_TREE then vim.cmd('TSUpdate') end
  --   end,
  --   cmd = 'TSUpdate',
  --   config = function()
  --     require('nvim-treesitter.configs').setup({
  --       auto_install = true,
  --       ensure_installed = {
  --         'lua',
  --         'astro',
  --         'typescript',
  --         'javascript',
  --         'tsx',
  --         'html',
  --       },
  --       highlight = {
  --         enable = true,
  --       },
  --       textsubjects = {
  --         enable = true,
  --       },
  --       indent = {
  --         enable = true,
  --       },
  --     })
  --   end,
  {
    'nvim-lualine/lualine.nvim',
    priority = 1000,
    opts = {
      options = {
        theme = 'auto',
        section_separators = '',
        component_separators = '',
      },
      sections = {
        lualine_b = { {
          'branch',
        } },
        lualine_c = {
          {
            'buffers',
            hide_filename_extension = true,
            mode = 4,
            symbols = {
              modified = ' ',
              alternate_file = '',
            },
          },
        },
        lualine_x = {
          {
            'diagnostics',
          },
        },
      },
    },
  }, -- },
})
