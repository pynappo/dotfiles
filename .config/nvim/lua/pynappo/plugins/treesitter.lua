return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    config = function()
      ---@diagnostic disable-next-line: param-type-mismatch
      require('nvim-treesitter').setup({
        auto_install = true,
        ensure_installed = {
          'stable',
          'unstable',
        },
      })
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(details)
          local bufnr = details.buf
          if not pcall(vim.treesitter.start, bufnr) then return end
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
      vim.treesitter.language.register('markdown', 'mdx')
    end,
    dependencies = {},
  },
  {
    'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
    config = function()
      local rainbow_highlight_names = require('pynappo.theme').set_rainbow_colors('RainbowDelimiter', {
        { 'Red', '#EF6D6D' },
        { 'Orange', '#FFA645' },
        { 'Yellow', '#EDEF56' },
        { 'Green', '#6AEF6F' },
        { 'Cyan', '#78E6EF' },
        { 'Blue', '#70A4FF' },
        { 'Violet', '#BDB2EF' },
      })
      local rainbow_delimiters = require('rainbow-delimiters')

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
        },
        highlight = rainbow_highlight_names,
      }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    config = true,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
}
