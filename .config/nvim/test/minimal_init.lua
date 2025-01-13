-- LazyNvim Setup
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
vim.opt.clipboard = 'unnamedplus'
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

vim.opt.laststatus = 0
vim.go.laststatus = 0

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
vim.keymap.set('n', '<leader>cc', 'gcc', { remap = true })
require('lazy').setup({
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    lazy = false,
    priority = 9000,
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
        hide_dotfiles = false,
        hide_gitignord = false,
        hide_hidden = false,
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          '.DS_Store',
        },
        never_show_by_pattern = { -- uses glob style patterns
          '.null-ls_*',
        },
        hijack_netrw_behavior = 'open_current',
      },
      default_component_configs = {
        modified = {
          symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = {
            added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = '', -- this can only be used in the git_status source
            renamed = '', -- this can only be used in the git_status source
            -- Status type
            untracked = '',
            ignored = '◌',
            unstaged = '',
            staged = '',
            conflict = '',
          },
        },
      },
    },
  },
})

vim.opt.laststatus = 0
vim.go.laststatus = 0
