local keymaps = require('pynappo.keymaps')
return {
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- { 'folke/neodev.nvim', config = true },
      'mfussenegger/nvim-jdtls',
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
      'yioneko/nvim-vtsls',
      {
        'mrcjkb/haskell-tools.nvim',
        version = '^3', -- Recommended
        lazy = false, -- This plugin is already lazy
      },
      'https://git.sr.ht/~p00f/clangd_extensions.nvim',
    },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'clangd',
        },
        automatic_enable = true,
      })
    end,
  },
  'mrcjkb/rustaceanvim',
  {
    'williamboman/mason.nvim',
    opts = {
      PATH = 'append',
    },
  },
}
