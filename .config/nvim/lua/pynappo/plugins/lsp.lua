local keymaps = require('pynappo.keymaps')
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- { 'folke/neodev.nvim', config = true },
      'mfussenegger/nvim-jdtls',
      'mrcjkb/rustaceanvim',
      'nvimtools/none-ls.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
      -- 'alaviss/nim.nvim',
      -- {
      --   'pmizio/typescript-tools.nvim',
      --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
      --   opts = {
      --     settings = {
      --       tsserver_file_preferences = {
      --         includeInlayParameterNameHints = 'all',
      --         includeCompletionsForModuleExports = true,
      --         quotePreference = 'auto',
      --       },
      --       tsserver_format_options = {
      --         allowIncompleteCompletions = false,
      --         allowRenameOfImportPath = false,
      --       },
      --     },
      --   },
      -- },
      {
        'yioneko/nvim-vtsls',
      },
      {
        'mrcjkb/haskell-tools.nvim',
        version = '^3', -- Recommended
        lazy = false, -- This plugin is already lazy
      },
      {
        'https://git.sr.ht/~p00f/clangd_extensions.nvim',
      },
    },
    init = keymaps.setup.diagnostics,
    config = function()
      local lspconfig = require('lspconfig')
      require('lspconfig.configs').vtsls = require('vtsls').lspconfig
      local handlers = {
        function(ls) lspconfig[ls].setup(require('pynappo/lsp/configs')[ls]) end,
        rust_analyzer = function() end, -- use rustaceanvim
        jdtls = function() end, -- use nvim-jdtls
        tsserver = function() end, -- use typescript-tools
        hls = function() end, -- use haskell-tools
      }
      -- if vim.fn.executable('ccls') == 1 then
      --   handlers.clangd = function() end
      --   require('lspconfig').ccls.setup({})
      -- end
      require('mason-lspconfig').setup({
        ensure_installed = {
          'clangd',
          'lua_ls',
          'rust_analyzer',
          'marksman',
          'jdtls',
          'powershell_es',
          'ltex',
          'clangd',
        },
        handlers = handlers,
      })
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gitrebase,
          null_ls.builtins.hover.dictionary,
          null_ls.builtins.hover.printenv,
        },
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      ui = { border = 'single' },
      PATH = 'append',
    },
  },
}
