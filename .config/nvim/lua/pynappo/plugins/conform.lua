local web_dev = { stop_after_first = true, 'biome', 'prettier' }
return {
  {
    'stevearc/conform.nvim',
    -- not lazyloading for heirline
    -- event = { 'BufWritePre' },
    -- cmd = { 'ConformInfo' },
    -- init = require('pynappo.keymaps').setup.conform(),
    opts = {
      -- Define your formatters
      ---@see vim.o.formatoptions
      formatters_by_ft = {
        go = { 'goimports', 'gofmt' },
        lua = { 'stylua' },
        cpp = { 'clang_format' },
        c = { 'clang_format' },
        typescript = web_dev,
        javascript = web_dev,
        typescriptreact = web_dev,
        javascriptreact = web_dev,
        typst = { 'typstyle' },
        ruby = { 'prettier' },
        svelte = { 'prettier' },
        prisma = { 'prettier' },
        css = web_dev,
        less = { 'deno_fmt' },
        json = { 'jq' },
        -- ['*'] = { 'codespell' },
        ['_'] = { 'trim_whitespace' },
      },
      -- Set up format-on-save
      -- format_on_save = {
      --   timeout_ms = nil,
      --   lsp_fallback = true,
      -- },
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
    config = function(_, opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = vim.tbl_keys(require('conform').formatters_by_ft),
        group = vim.api.nvim_create_augroup('conform_formatexpr', { clear = true }),
        callback = function() vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()' end,
      })
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      require('conform').setup(opts)
      vim.g.auto_conform_on_save = true
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*',
        callback = function(args)
          if vim.g.auto_conform_on_save then require('conform').format({ bufnr = args.buf, timeout_ms = nil }) end
        end,
      })
      vim.api.nvim_create_user_command('ConformToggleOnSave', function()
        vim.g.auto_conform_on_save = not vim.g.auto_conform_on_save
        vim.notify('Auto-Conform on save: ' .. (vim.g.auto_conform_on_save and 'Enabled' or 'Disabled'))
      end, {})
    end,
  },
}
