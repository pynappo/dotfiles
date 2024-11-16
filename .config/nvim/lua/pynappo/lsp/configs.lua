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
  gdscript = {
    cmd = require('pynappo.utils').is_windows and { 'ncat', '127.0.0.1', '6005' }
      or vim.lsp.rpc.connect('127.0.0.1', 6005),
  },
  eslint = {
    settings = {
      -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
      workingDirectories = { mode = 'auto' },
    },
  },
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
  vtsls = {
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
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
}

local autocmd = require('pynappo.autocmds').create
autocmd({ 'LspAttach' }, {
  callback = function(details)
    local bufnr = details.buf
    local client = vim.lsp.get_client_by_id(details.data.client_id) or {}
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

    if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end
    if client.server_capabilities.codeLensProvider then
      autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        callback = function() vim.lsp.codelens.refresh({ bufnr = 0 }) end,
        buffer = bufnr,
      })
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'codelens', buffer = bufnr })
    end
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
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
