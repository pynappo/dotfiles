local github = require('pynappo.utils').repourl.github
vim.pack.add({
  github('rgroli/other.nvim'),
  github('dstein64/vim-startuptime'),
  github('pynappo/hyprlang-to-lua.nvim'),
})
require('other-nvim').setup({
  mappings = {
    'c',
    {
      -- context = "C header",
      pattern = '(.*).cpp$',
      target = '%1.h',
    },
    {
      -- context = "C header",
      pattern = '(.*).h$',
      target = '%1.cpp',
    },
  },
})
