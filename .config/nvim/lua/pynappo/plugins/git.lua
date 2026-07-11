local github = require('pynappo.utils').repourl.github
vim.pack.add({
  github('nvim-tree/nvim-web-devicons'),
  github('tpope/vim-fugitive'),
  github('tpope/vim-rhubarb'),
  github('linrongbin16/gitlinker.nvim'),
  github('NeogitOrg/neogit'),
  github('nvim-lua/plenary.nvim'), -- required
  github('nvim-telescope/telescope.nvim'), -- optional
  github('sindrets/diffview.nvim'), -- optional
  github('pwntester/octo.nvim'),
  github('nvim-lua/plenary.nvim'),
  github('nvim-telescope/telescope.nvim'),
  github('lewis6991/gitsigns.nvim'),
  github('sindrets/diffview.nvim'),
  github('akinsho/git-conflict.nvim'),
})
require('gitlinker').setup()
require('git-conflict').setup({})
require('gitsigns').setup({
  signs = {
    add = {
      text = '│',
    },
    change = {
      text = '│',
    },
    delete = {
      text = '_',
    },
    topdelete = {
      text = '‾',
    },
    changedelete = {
      text = '~',
    },
  },
  signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_formatter = '<author>@<author_time:%Y-%m-%d>: <summary>',
  max_file_length = 20000, -- Disable if file is longer than this (in lines)
  sign_priority = 2,
})
