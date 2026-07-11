local github = require('pynappo.utils').repourl.github
vim.pack.add({
  github('bennypowers/nvim-regexplainer'),
  github('neovim-treesitter/nvim-treesitter'),
  github('MunifTanjim/nui.nvim'),
  github('AckslD/muren.nvim'),
})
require('regexplainer').setup()
