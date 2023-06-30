local default_config = {
  on_attach = function(client, bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    require('pynappo/keymaps').setup.lsp(bufnr)
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
        hint = {
          enable = true,
        },
        diagnostics = {
          globals = {'vim'},
        }
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
    on_attach = function(_, bufnr)
      require('pynappo/keymaps').setup.jdtls(bufnr)
      require('jdtls').setup_dap({ hotcodereplace = 'auto' })
      require('jdtls.setup').add_commands()
    end,
  }
}

for key, config in pairs(configs) do
  config = vim.tbl_deep_extend("force", default_config, config)
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
