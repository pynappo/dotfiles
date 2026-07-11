local github = require('pynappo.utils').repourl.github
vim.pack.add({
  github('AckslD/nvim-FeMaco.lua'),
  github('wallpants/github-preview.nvim'),
  -- {
  --   'OXY2DEV/markview.nvim',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'echasnovski/mini.icons',
  --   },
  -- },
})
local gpreview = require('github-preview')
gpreview.setup({})

local fns = gpreview.fns
vim.keymap.set('n', '<leader>mpt', fns.toggle)
vim.keymap.set('n', '<leader>mps', fns.single_file_toggle)
vim.keymap.set('n', '<leader>mpd', fns.details_tags_toggle)
require('femaco').setup()
