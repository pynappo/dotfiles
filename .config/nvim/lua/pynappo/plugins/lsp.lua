
return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      { 'folke/neodev.nvim', config = true },
      'mfussenegger/nvim-jdtls',
      'simrat39/rust-tools.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'williamboman/mason-lspconfig.nvim',
      'alaviss/nim.nvim',
    },
    init = function() require('pynappo/keymaps').setup.diagnostics() end,
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "marksman",
          "jdtls",
          "powershell_es",
          "ltex",
        },
        handlers = {
          function(ls) require('lspconfig')[ls].setup(require('pynappo/lsp/configs')[ls]) end,
          rust_analyzer = function() require('rust-tools').setup() end,
          jdtls = function() end, -- use method recommended by nvim-jdtls
        }
      })
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.completion.spell.with({
            filetypes = { 'markdown', 'text' },
          }),
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.formatting.codespell
        },
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = { ui = { border = 'single' } }
  }
}
