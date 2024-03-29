local keymaps = require('pynappo.keymaps')
return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'folke/neodev.nvim', config = true },
      'mfussenegger/nvim-jdtls',
      'mrcjkb/rustaceanvim',
      'nvimtools/none-ls.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
      -- 'alaviss/nim.nvim',
      {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = {
          settings = {
            tsserver_file_preferences = {
              includeInlayParameterNameHints = 'all',
              includeCompletionsForModuleExports = true,
              quotePreference = 'auto',
            },
            tsserver_format_options = {
              allowIncompleteCompletions = false,
              allowRenameOfImportPath = false,
            },
          },
        },
      },
      {
        'https://git.sr.ht/~p00f/clangd_extensions.nvim',
      },
    },
    init = keymaps.setup.diagnostics,
    config = function()
      local handlers = {
        function(ls) require('lspconfig')[ls].setup(require('pynappo/lsp/configs')[ls]) end,
        rust_analyzer = function() end, -- use rustaceanvim
        jdtls = function() end, -- use nvim-jdtls
        tsserver = function() end, -- use typescript-tools
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
          -- null_ls.builtins.completion.spell.with({
          --   filetypes = { 'markdown', 'text' },
          -- }),
          -- null_ls.builtins.code_actions.gitsigns,
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
