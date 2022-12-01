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

local configs = {
  default = {
    {
      on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        for _, map in pairs(require('pynappo/keymaps').lsp.on_attach) do
          vim.api.nvim_buf_set_keymap(bufnr, map[1], map[2], map[3], {silent = true})
        end
        require('nvim-navic').attach(client, bufnr)
      end,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      flags = {debounce_text_changes = 200}
    }
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
local lspconfig = require('lspconfig')
mason_lspconfig.setup_handlers {
  function(ls) lspconfig[ls].setup(vim.tbl_deep_extend("force", configs.default, configs[ls] or {})) end,
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
