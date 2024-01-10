local prettier = { 'prettierd', 'prettier' }
return {
  {
    'stevearc/conform.nvim',
    -- not lazyloading for heirline
    -- event = { 'BufWritePre' },
    -- cmd = { 'ConformInfo' },
    -- init = require('pynappo.keymaps').setup.conform(),
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { 'stylua' },
        cpp = { 'clang_format' },
        typescript = { prettier },
        javascript = { prettier },
        typescriptreact = { prettier },
        javascriptreact = { prettier },
      },
      -- Set up format-on-save
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function(_, opts)
      require('conform').setup(opts)
      -- vim.api.nvim_create_autocmd('BufWritePre', {
      --   pattern = '*',
      --   callback = function(args) require('conform').format({ bufnr = args.buf }) end,
      -- })
    end,
  },
}
