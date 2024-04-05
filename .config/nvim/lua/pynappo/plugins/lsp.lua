local keymaps = require('pynappo.keymaps')
return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'folke/neodev.nvim', config = true },
      'mfussenegger/nvim-jdtls',
      'mrcjkb/rustaceanvim',
      'nvimtools/none-ls.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
      -- 'alaviss/nim.nvim',
      {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = {
          settings = {
            tsserver_file_preferences = {
              includeInlayParameterNameHints = 'all',
              includeCompletionsForModuleExports = true,
              quotePreference = 'auto',
            },
            tsserver_format_options = {
              allowIncompleteCompletions = false,
              allowRenameOfImportPath = false,
            },
          },
        },
      },
      {
        'https://git.sr.ht/~p00f/clangd_extensions.nvim',
      },
    },
    init = keymaps.setup.diagnostics,
    config = function()
      local lspconfig = require('lspconfig')
      -- lspconfig.util.add_hook_after(lspconfig.util.on_setup, function(config)
      --   if config.name == 'lua_ls' then
      --     -- workaround for nvim's incorrect handling of scopes in the workspace/configuration handler
      --     -- https://github.com/folke/neodev.nvim/issues/41
      --     -- https://github.com/LuaLS/lua-language-server/issues/1089
      --     -- https://github.com/LuaLS/lua-language-server/issues/1596
      --     config.handlers = vim.tbl_extend('error', {}, config.handlers)
      --     config.handlers['workspace/configuration'] = function(...)
      --       local _, result, ctx = ...
      --       local client_id = ctx.client_id
      --       local client = vim.lsp.get_client_by_id(client_id)
      --       if client and client.workspace_folders and #client.workspace_folders then
      --         if result.items and #result.items > 0 then
      --           if not result.items[1].scopeUri then return vim.tbl_map(function(_) return nil end, result.items) end
      --         end
      --       end
      --
      --       return vim.lsp.handlers['workspace/configuration'](...)
      --     end
      --   end
      -- end)
      local handlers = {
        function(ls) lspconfig[ls].setup(require('pynappo/lsp/configs')[ls]) end,
        rust_analyzer = function() end, -- use rustaceanvim
        jdtls = function() end, -- use nvim-jdtls
        tsserver = function() end, -- use typescript-tools
      }
      -- if vim.fn.executable('ccls') == 1 then
      --   handlers.clangd = function() end
      --   require('lspconfig').ccls.setup({})
      -- end
      require('mason-lspconfig').setup({
        ensure_installed = {
          'clangd',
          'lua_ls',
          'rust_analyzer',
          'marksman',
          'jdtls',
          'powershell_es',
          'ltex',
          'clangd',
        },
        handlers = handlers,
      })
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gitrebase,
          null_ls.builtins.hover.dictionary,
          null_ls.builtins.hover.printenv,
        },
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      ui = { border = 'single' },
      PATH = 'append',
    },
  },
}
