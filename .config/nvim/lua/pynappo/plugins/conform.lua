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
        ruby = { prettier },
      },
      -- Set up format-on-save
      format_on_save = {
        timeout_ms = 10000,
        lsp_fallback = true,
      },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
        prettier = {
          -- Use a specific prettier parser for a filetype
          -- Otherwise, prettier will try to infer the parser from the file name
          ft_parsers = {
            --     javascript = "babel",
            --     javascriptreact = "babel",
            --     typescript = "typescript",
            --     typescriptreact = "typescript",
            --     vue = "vue",
            --     css = "css",
            --     scss = "scss",
            --     less = "less",
            --     html = "html",
            --     json = "json",
            --     jsonc = "json",
            --     yaml = "yaml",
            --     markdown = "markdown",
            --     ["markdown.mdx"] = "mdx",
            --     graphql = "graphql",
            --     handlebars = "glimmer",
            -- ruby = 'ruby',
          },
          -- Use a specific prettier parser for a file extension
          ext_parsers = {
            -- rb = 'ruby',
          },
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
