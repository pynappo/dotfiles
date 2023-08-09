local keymaps = require('pynappo.keymaps')
local default_config = {
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
      keymaps.setup.jdtls(bufnr)
      require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    end,
  }
}

require('pynappo.autocmds').create({'LspAttach'}, {
  callback = function(details)
    local bufnr = details.buf
    local client = vim.lsp.get_client_by_id (details.data.client_id)
    if not client then return end
    if vim.tbl_contains({'copilot', 'null-ls'}, client.name or vim.print('no client found')) then return end

    if vim.b[bufnr].lsp_attached then return end
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    keymaps.setup.lsp(bufnr)
    require('pynappo.autocmds').create({'CursorHold'}, {
      callback = function()
        for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.bo[vim.api.nvim_win_get_buf(winid)].filetype == 'noice' then return end
        end
        vim.lsp.buf.hover()
      end,
      buffer = bufnr
    })
    vim.b[bufnr].lsp_attached = true
  end
})

for key, config in pairs(configs) do
  config = vim.tbl_deep_extend("force", default_config, config)
  configs[key] = config
end

setmetatable(configs, {
  __index = function()
    return default_config
  end
})


return configs
