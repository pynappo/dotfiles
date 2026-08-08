local utils = require('pynappo.utils')
local github = utils.repourl.github
vim.pack.add({
  {
    src = github('nvim-neotest/neotest'),
    lazy = true,
  },
  github('nvim-treesitter/nvim-treesitter'),
  github('rouge8/neotest-rust'),
  github('nvim-neotest/nvim-nio'),
})
