local default_config = {
  on_attach = function(client, bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    require('pynappo/keymaps').setup.lsp(bufnr)
    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, bufnr)
    end
  end,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = {debounce_text_changes = 200}
}
local configs = {
  lua_ls = {
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
    end,
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Both',
        },
        workspace = {
          checkThirdParty = false,
        },
      }
    },
  },
  ltex = {
    filetypes = {
      "bib",
      "gitcommit",
      "org",
      "plaintex",
      "rst",
      "rnoweb",
      "tex",
    }
  },
  jdtls = {
    on_attach = function(client, bufnr)
      require('pynappo/keymaps').setup.jdtls(bufnr)
      require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    end,
  }
}

for key, config in pairs(configs) do
  config = vim.tbl_deep_extend("force", default_config, {})
  if config.on_attach then
    local on_attach = config.on_attach
    config.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      default_config.on_attach(client, bufnr)
    end
  end
  configs[key] = config
end

setmetatable(configs, {
  __index = function()
    return default_config
  end
})


return configs
