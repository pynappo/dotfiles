local keymaps = require('pynappo.keymaps')
local default_config = {
  capabilities = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
  ),
  flags = { debounce_text_changes = 200 },
}
local configs = {
  clangd = {
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern(
        'Makefile',
        'configure.ac',
        'configure.in',
        'config.h.in',
        'meson.build',
        'meson_options.txt',
        'build.ninja'
      )(fname) or require('lspconfig.util').root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or require(
        'lspconfig.util'
      ).find_git_ancestor(fname)
    end,
    capabilities = {
      offsetEncoding = { 'utf-16' },
    },
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
    },
  },
  lua_ls = {
    -- before_init = require('neodev.lsp').before_init,
    on_init = function(client)
      local path = vim.tbl_get(client, 'workspace_folders', 1, 'name')
      if not path then return true end
      local nvim_workspace = path:find('nvim') or path:find('lua')
      local test_nvim = path:find('test')
      if nvim_workspace then
        local library = test_nvim and { vim.env.VIMRUNTIME } or vim.api.nvim_get_runtime_file('lua', true)
        -- add lazy-loaded plugins:
        if package.loaded['lazy'] then
          for _, plugin in ipairs(require('lazy').plugins()) do
            local lua_plugin_dir = plugin.dir .. '/lua'
            if not plugin._.loaded and vim.uv.fs_stat(lua_plugin_dir) then table.insert(library, lua_plugin_dir) end
          end
        end
        library = vim.tbl_map(function(lib) return vim.fs.normalize(lib) end, library)
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
          Lua = {
            runtime = {
              version = 'LuaJIT',
              pathStrict = true,
            },
            workspace = {
              library = library,
            },
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
        hint = {
          enable = true,
          arrayIndex = 'Disable',
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

    if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(bufnr) end
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
