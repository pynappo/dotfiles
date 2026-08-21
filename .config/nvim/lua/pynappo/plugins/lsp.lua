local keymaps = require('pynappo.keymaps')

local github = require('pynappo.utils').repourl.github
vim.pack.add({
  {
    src = github('folke/lazydev.nvim'),
  },
  github('neovim/nvim-lspconfig'),
  github('mfussenegger/nvim-jdtls'),
  github('williamboman/mason-lspconfig.nvim'),
  github('williamboman/mason.nvim'),
  github('yioneko/nvim-vtsls'),
  {
    src = github('mrcjkb/haskell-tools.nvim'),
    version = vim.version.range('^3'), -- Recommended
  },
  'https://git.sr.ht/~p00f/clangd_extensions.nvim',
  github('mrcjkb/rustaceanvim'),
  github('williamboman/mason.nvim'),
})
require('mason').setup({
  PATH = 'append',
})
require('mason-lspconfig').setup({
  ensure_installed = {},
  automatic_enable = true,
})
require('lazydev').setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})
