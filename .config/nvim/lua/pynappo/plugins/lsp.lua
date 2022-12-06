local M = {}
local configs = {
  default = {
    on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      require('pynappo/keymaps').setup.lsp(bufnr)
      require('nvim-navic').attach(client, bufnr)
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    flags = {debounce_text_changes = 200}
  },
  sumneko_lua = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        }
      }
    }
  }
}
function M.get_config(ls)
  return vim.tbl_deep_extend("force", configs.default, configs[ls] or {})
end

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

require('neodev').setup({})
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = {
    "sumneko_lua",
    "html",
    "jdtls",
    "jsonls",
    "ltex",
    "powershell_es",
    "pylsp",
    "theme_check",
    "zls",
    "csharp_ls",
    "rust_analyzer",
    "gopls",
  },
  automatic_installation = true
})
require('pynappo/keymaps').setup.diagnostics()

local lspconfig = require('lspconfig')
mason_lspconfig.setup_handlers {
  function(ls) lspconfig[ls].setup(M.get_config(ls)) end,
  rust_analyzer = function() require('rust-tools').setup() end,
  jdtls = function() end, -- use method recommended by nvim-jdtls instead with ftplugins
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
return M
