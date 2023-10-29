local keymaps = require('pynappo.keymaps')
return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'folke/neodev.nvim', config = true },
      'mfussenegger/nvim-jdtls',
      'mrcjkb/rustaceanvim',
      'jose-elias-alvarez/null-ls.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
      'alaviss/nim.nvim',
    },
    init = keymaps.setup.diagnostics,
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "marksman",
          "jdtls",
          "powershell_es",
          "ltex",
        },
        handlers = {
          function(ls) require('lspconfig')[ls].setup(require('pynappo/lsp/configs')[ls]) end,
          rust_analyzer = function() end, -- use rustaceanvim
          jdtls = function() end, -- use method recommended by nvim-jdtls
        }
      })

      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.completion.spell.with({
            filetypes = { 'markdown', 'text' },
          }),
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.formatting.codespell
        },
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = { ui = { border = 'single' } }
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = require('pynappo.keymaps').setup.conform({lazy = true}),
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr({timeout_ms = 5000})"
    end,
    config = function(_, opts)
      require('conform').setup(opts)
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end
  }
}
