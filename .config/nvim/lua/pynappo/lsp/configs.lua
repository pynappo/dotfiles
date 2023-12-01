local keymaps = require('pynappo.keymaps')
local default_config = {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  flags = { debounce_text_changes = 200 },
}
local configs = {
  lua_ls = {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      local nvim_workspace = path:find('nvim')
      local test_nvim = path:find('test')
      if nvim_workspace then
        local library = test_nvim and { vim.env.VIMRUNTIME } or vim.api.nvim_get_runtime_file('lua', true)
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            pathStrict = true,
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            library = library,
          },
        })
        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
      end
      return true
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
          globals = { 'vim' },
        },
        telemetry = {
          enable = true,
        },
      },
    },
  },
  ltex = {
    filetypes = {
      'bib',
      'gitcommit',
      'org',
      'plaintex',
      'rst',
      'rnoweb',
      'tex',
    },
  },
  jdtls = {
    on_attach = function(_, bufnr)
      keymaps.setup.jdtls(bufnr)
      require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    end,
  },
}

require('pynappo.autocmds').create({ 'LspAttach' }, {
  callback = function(details)
    local bufnr = details.buf
    local client = vim.lsp.get_client_by_id(details.data.client_id) or {}
    -- local config = vim.tbl_get(client, 'config')
    -- if config then
    --   table.sort(config)
    --   vim.print(#config, config)
    -- end
    if not client then return end
    if vim.tbl_contains({ 'copilot', 'null-ls' }, client.name or vim.print('no client found')) then return end

    -- local ok, hover = pcall(require, 'hover')
    -- hover = ok and hover.hover() or vim.lsp.buf.hover
    -- if not vim.b[bufnr].lsp_attached then
    --   require('pynappo.autocmds').create({ 'CursorHold' }, {
    --     callback = function()
    --       for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    --         if vim.bo[vim.api.nvim_win_get_buf(winid)].filetype == 'noice' then return end
    --       end
    --       hover()
    --     end,
    --     buffer = bufnr,
    --   })
    -- end
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    keymaps.setup.lsp(bufnr)
    vim.b[bufnr].lsp_attached = true
  end,
})

for key, config in pairs(configs) do
  ---@diagnostic disable-next-line: cast-local-type
  config = vim.tbl_deep_extend('force', default_config, config)
  configs[key] = config
end

setmetatable(configs, {
  __index = function() return default_config end,
})

return configs
