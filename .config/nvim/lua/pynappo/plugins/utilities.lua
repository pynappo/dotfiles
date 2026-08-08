local github = require('pynappo.utils').repourl.github
vim.pack.add({
  github('bennypowers/nvim-regexplainer'),
  github('nvim-treesitter/nvim-treesitter'),
  github('MunifTanjim/nui.nvim'),
  github('AckslD/muren.nvim'),
})
require('regexplainer').setup({
  filetypes = {
    'html',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'ruby',
    'python',
    'go',
    'rust',
    'php',
    'java',
    'cs',
    'lua',
  },
})
