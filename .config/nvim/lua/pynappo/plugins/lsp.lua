local M = {}
local configs = {
  default = {
    on_attach = function(client, bufnr)
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
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
        },
        diagnostics = {
          globals = {'vim'}
        },
      }
    }
  }
}
function M.get_config(ls) return vim.tbl_deep_extend("force", configs.default, configs[ls] or {}) end

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
require('mason-tool-installer').setup {
  ensure_installed = {
    'codespell',
    'cpptools',
    'csharp-language-server',
    'gopls',
    -- 'html-lsp',
    'java-debug-adapter',
    'java-test',
    'jdtls',
    -- 'json-lsp',
    -- 'ltex-ls',
    'lua-language-server',
    'marksman',
    'netcoredbg',
    'nimlsp',
    'powershell-editor-services',
    'python-lsp-server',
    'rust-analyzer',
    -- 'shopify-theme-check',
    'stylua',
    'zls',
  },
}

require('pynappo/keymaps').setup.diagnostics()

local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
mason_lspconfig.setup()
mason_lspconfig.setup_handlers {
  function(ls) lspconfig[ls].setup(M.get_config(ls)) end,
  rust_analyzer = function() require('rust-tools').setup() end,
  jdtls = function() end, -- use method recommended by nvim-jdtls @ ftplugin/java.lua
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