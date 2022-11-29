require('neodev').setup({})
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = { "sumneko_lua", "html", "jdtls", "jsonls", "ltex", "powershell_es", "pylsp", "theme_check", "zls", "csharp_ls", "rust_analyzer", "gopls"},
  automatic_installation = true
})
require('pynappo/keymaps').setup.diagnostics()

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  float = {
    border = "single",
    format = function(diagnostic)
      return string.format(
        "%s (%s) [%s]",
        diagnostic.message,
        diagnostic.source,
        diagnostic.code or diagnostic.user_data.lsp.code
      )
    end,
  },
})

local configs = require('pynappo/plugins/lsp/configs')
local lspconfig = require('lspconfig')
mason_lspconfig.setup_handlers {
  function(ls) lspconfig[ls].setup(vim.tbl_deep_extend("force", configs.defaults, configs[ls] or {})) end,
  ['rust_analyzer'] = function() require('rust-tools').setup() end,
}

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.completion.spell.with({
      filetypes = { 'markdown', 'text' },
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.hover.dictionary,
    null_ls.builtins.hover.printenv,
    null_ls.builtins.formatting.codespell
  },
})
