require('neodev').setup({})
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = { "sumneko_lua", "html", "jdtls", "jsonls", "ltex", "powershell_es", "pylsp", "theme_check", "zls", "csharp_ls", "rust_analyzer", "gopls"},
  automatic_installation = true
})
require('pynappo/keymaps').setup('diagnostics')

mason_lspconfig.setup_handlers {
  function(ls)
    local config = require('pynappo/plugins/lsp/config/defaults')
    local ok, override = pcall(require, 'pynappo/plugins/lsp/config/' .. ls)
    if ok then config = vim.tbl_deep_extend('force', config, override) end
    require('lspconfig')[ls].setup(config)
  end,
  ['rust_analyzer'] = function()
      require('rust-tools').setup()
  end,
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
